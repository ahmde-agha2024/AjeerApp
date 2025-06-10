import 'package:ajeer/bussiness/drawer_provider.dart';
import 'package:ajeer/ui/widgets/appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SubscriptionPaymentScreen extends StatefulWidget {
  final String selectedUrl;

  SubscriptionPaymentScreen({required this.selectedUrl, super.key});

  @override
  State<SubscriptionPaymentScreen> createState() => _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState extends State<SubscriptionPaymentScreen> {
  late WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {

          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            print(request.url);
            print('NavigationRequest: ${request.url}');
            if (request.url.contains('order/result/')) {
              // pop all until ProviderHomeScreen
              Provider.of<DrawerProvider>(context, listen: false).zoomDrawerController.close!();
              Navigator.popUntil(context, (route) => route.isFirst);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text('Payment Successful!'), // TODO TRANSLATE
                ),
              );
            } else if (request.url.contains('/order/failed/')) {
              String errorMessage = '';
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text('Payment failed!'), // TODO TRANSLATE
                  backgroundColor: Colors.red,
                ),
              );
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.selectedUrl));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(title: 'دفع إشتراك باقة'), // TODO TRANSLATE
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
