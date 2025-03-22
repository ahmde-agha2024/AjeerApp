import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/general/about_app_controller.dart';
import 'package:ajeer/models/general/about_app_model.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../constants/my_colors.dart';
import '../widgets/appbar_title.dart';
import '../widgets/sized_box.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  bool isLoaded = false;
  ResponseHandler<List<Faq>>? responseHandler;

  @override
  void didChangeDependencies() {
    if (!isLoaded) {
      Provider.of<AboutApp>(context, listen: false).fetchFaq().then((value) {
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
        title: 'الاسئلة الشائعة',
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding for better layout
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                color: Colors.grey.withOpacity(0.1),
                thickness: 10,
              ),
              SizedBoxedH32,
              !isLoaded
                  ? loaderWidget(context,type: 'default')
                  : responseHandler!.status == ResponseStatus.error
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 12),
                                    child: Text(
                                      'Try Again'.tr(), // TODO TRANSLATE
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
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
                      : ListView.builder(
                          itemCount: responseHandler!.response!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ExpansionTile(
                              title: Text(
                                responseHandler!.response![index].title!,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: HtmlWidget(
                                    responseHandler!.response![index].content!,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
