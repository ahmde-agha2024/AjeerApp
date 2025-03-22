import 'package:ajeer/constants/my_colors.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/general/about_app_controller.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../widgets/appbar_title.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool isLoaded = false;
  ResponseHandler<String>? responseHandler;

  @override
  void didChangeDependencies() {
    if (!isLoaded) {
      Provider.of<AboutApp>(context, listen: false).fetchTermsAndConditions().then((value) {
        setState(() {
          isLoaded = true;
          responseHandler = value;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(
        title: 'الشروط والأحكام', // TODO TRANSLATE
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: !isLoaded
            ? loaderWidget(context)
            : responseHandler?.status == ResponseStatus.error
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      errorWidget(context),
                      Builder(
                        builder: (context) => MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            color: MyColors.MainBulma,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                              child: Text(
                                'Try Again'.tr(), // TODO TRANSLATE
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isLoaded = false;
                                didChangeDependencies();
                              });
                            }),
                      )
                    ],
                  )
                : HtmlWidget(
                    responseHandler?.response ?? '',
                  ),
      ),
    );
  }
}
