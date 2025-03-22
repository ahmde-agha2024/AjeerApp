import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../constants/my_colors.dart';
import '../../screens/auth/verify_code_password_screen.dart';
import '../button_styles.dart';

Future showAccountCreatedBottomSheet(BuildContext ctx, String phoneNumber) {
  return showModalBottomSheet(
      context: ctx,
      builder: (context) {
        bool _isLoading = false;
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListView(
              children: [
                const SizedBox(height: 32),
                Lottie.asset('assets/lottie/success.json', height: 160, width: 160),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Account created successfully , Please Verify Your Account'.tr(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: MyColors.Darkest),
                  ),
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: TextButton(
                          style: flatButtonStyle,
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  ResponseHandler handledResponse = await Provider.of<Auth>(context, listen: false).sendOTP(phoneNumber: phoneNumber);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (handledResponse.status == ResponseStatus.success) {
                                    // show toast
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('OTP sent successfully'), // TODO: TRANSLATE THIS
                                    ));
                                  } else if (handledResponse.errorMessage != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(handledResponse.errorMessage!.tr())),
                                    );
                                  } else {
                                    // show toast
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('Error while sending OTP'), // TODO: TRANSLATE THIS
                                    ));
                                  }
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => VerifyCodePasswordScreen(
                                            isRegisterScreen: true,
                                            phoneNumber: phoneNumber,
                                          )));
                                },
                          child: Text(
                            'Verify Account'.tr(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                        ),
                      ),
              ],
            ),
          );
        });
      });
}
