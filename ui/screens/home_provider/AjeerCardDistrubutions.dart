import 'package:ajeer/constants/my_colors.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/general/about_app_controller.dart';
import 'package:ajeer/models/general/about_app_model.dart';
import 'package:ajeer/ui/widgets/appbar_title.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/rendering.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io' show Platform;
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../widgets/button_styles.dart';
import '../../widgets/sized_box.dart';

class AjeerDistributionsScreen extends StatefulWidget {
  const AjeerDistributionsScreen({super.key});

  @override
  State<AjeerDistributionsScreen> createState() =>
      _AjeerDistributionsScreenState();
}

class _AjeerDistributionsScreenState extends State<AjeerDistributionsScreen> {
  bool _isFetched = false;
  ResponseHandler<AboutAppModel> aboutApp =
      ResponseHandler(status: ResponseStatus.error);
  late final WebViewController _controller;
  bool isLoading = true;
  
  final String mapUrl = 'https://www.google.com/maps/d/viewer?mid=1JGgkRmGdOelq643QWGjJVXjgpK8EqaE&ll=32.8872%2C13.1913&z=12';

  @override
  void didChangeDependencies() {
    if (!_isFetched) {
      Provider.of<AboutApp>(context, listen: false)
          .fetchAboutApp()
          .then((value) {
        setState(() {
          aboutApp = value;
          _isFetched = true;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            _adjustZoom();
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(mapUrl));
  }

  Future<void> _adjustZoom() async {
    await _controller.runJavaScript('''
      try {
        document.querySelector('iframe').contentWindow.postMessage({
          'command': 'setZoom',
          'zoom': 12
        }, '*');
      } catch(e) {
        console.error('Error adjusting zoom:', e);
      }
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(title: 'موزعين كروت أجير'),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Divider(
              color: Colors.grey.withOpacity(0.1),
              thickness: 10,
            ),
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(
                    controller: _controller,
                  ),
                  if (isLoading)
                    _buildShimmer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
      ),
    );
  }
}
