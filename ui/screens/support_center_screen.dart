import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/general/about_app_controller.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../widgets/appbar_title.dart';
import '../widgets/button_styles.dart';
import '../widgets/input_decoration.dart';
import '../widgets/input_label.dart';

class SupportCenterScreen extends StatefulWidget {
  const SupportCenterScreen({super.key});

  @override
  State<SupportCenterScreen> createState() => _SupportCenterScreenState();
}

class _SupportCenterScreenState extends State<SupportCenterScreen> {
  bool isSendingMessage = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(
        title: 'الدعم الفني',
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
              color: Colors.grey.withOpacity(0.1),
              thickness: 10,
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const LabelText(text: 'العنوان'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: titleController,
                    decoration: buildInputDecoration(hintText: 'الرسالة'),
                  ),
                  const SizedBox(height: 16),
                  const LabelText(text: 'الرسالة'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: messageController,
                    decoration: buildInputDecoration(hintText: 'الرسالة'),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'أكتب رسالتك بالتفصيل  وسيقوم أحد أعضاء فريقنا بالإجابة على سؤالك في أقرب وقت ممكن.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  isSendingMessage
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: TextButton(
                            style: flatButtonPrimaryStyle,
                            onPressed: () async {
                              setState(() {
                                isSendingMessage = true;
                              });
                              ResponseHandler response = await Provider.of<AboutApp>(context, listen: false).contactUs(titleController.text, messageController.text);
                              setState(() {
                                isSendingMessage = false;
                              });
                              if (response.status == ResponseStatus.success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('تم إرسال الرسالة بنجاح'.tr())),
                                );
                                Navigator.pop(context);
                              } else if (response.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(response.errorMessage!.tr())),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error Occurred".tr())),
                                );
                              }
                            },
                            child: Text(
                              'إرسال'.tr(),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
