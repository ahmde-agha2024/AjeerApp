import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:ajeer/ui/screens/auth/verify_code_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../constants/my_colors.dart';
import '../../widgets/auth/appbar_auth.dart';
import '../../widgets/button_styles.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  var phoneController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarAuth(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Recover password'.tr(),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Enter your registered mobile number to recover your password'.tr(),
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        'Phone Number'.tr(),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: MyColors.Darkest),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  phoneNumber(),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: TextButton(
                            style: flatButtonStyle,
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              setState(() {
                                _isLoading = true;
                              });
                              ResponseHandler response = await Provider.of<Auth>(context, listen: false).sendOTP(phoneNumber: phoneController.text);
                              if (response.status == ResponseStatus.success) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => VerifyCodePasswordScreen(
                                          phoneNumber: phoneController.text,
                                        )));
                              } else if (response.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(response.errorMessage!.tr())),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error Occurred".tr())),
                                );
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            },
                            child: Text(
                              'Continue'.tr(),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Remember your password ? '.tr(),
                    style: const TextStyle(
                      color: MyColors.Darkest,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 2),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Back to login'.tr(),
                      style: const TextStyle(
                        color: MyColors.MainBulma,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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

  Widget phoneNumber() {
    return TextFormField(
      readOnly: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: phoneController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'من فضلك أدخل رقم الهاتف';
        }
        if (value.length < 10) {
          return 'رقم الهاتف يجب أن يكون 10 أرقام على الأقل';
        }
        if (!value.startsWith('09')) {
          return 'رقم الهاتف يجب أن يبدأ بـ 09';
        }
        return null;
      },
      maxLines: 1,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.red, style: BorderStyle.solid),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: MyColors.MainBeerus, style: BorderStyle.solid),
        ),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: MyColors.MainBeerus,
            )),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.red, style: BorderStyle.solid),
        ),
        hintText: 'ex: 09XXXXXXXX'.tr(),
        alignLabelWithHint: true,
        hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: MyColors.LightDark),
      ),
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: MyColors.Darkest),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
