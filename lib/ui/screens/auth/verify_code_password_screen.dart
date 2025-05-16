import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:ajeer/ui/screens/auth/auth_screen.dart';
import 'package:ajeer/ui/screens/home_client/tabs_screen.dart';
import 'package:ajeer/ui/screens/home_provider/tabs_provider_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../../constants/my_colors.dart';
import '../../widgets/auth/appbar_auth.dart';
import '../../widgets/button_styles.dart';
import '../../widgets/input_decoration.dart';
import '../../widgets/input_label.dart';

class VerifyCodePasswordScreen extends StatefulWidget {
  bool isRegisterScreen;
  final String phoneNumber;
  VerifyCodePasswordScreen({
    required this.phoneNumber,
    super.key,
    this.isRegisterScreen = false,
  });

  @override
  State<VerifyCodePasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<VerifyCodePasswordScreen> {
  String pinOtp = "";
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  TextEditingController verfiyCodeController = TextEditingController();

  var phoneController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  int _resendTimer = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startResendTimer() {
    setState(() {
      _resendTimer = 90;
    });
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String get timerText {
    int minutes = _resendTimer ~/ 60;
    int seconds = _resendTimer % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        widget.isRegisterScreen
                            ? 'Verify Account'.tr() // TODO TRANSLATE THIS
                            : 'Recover password'.tr(),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "من فضلك أدخل رمز التحقق المرسل إلى "

                        +
                        widget.phoneNumber,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: PinCodeTextField(
                      appContext: context,
                      controller: verfiyCodeController,
                      length: 6,
                      onChanged: (pin) {
                        pinOtp = pin;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please_enter_verify_code'.tr();
                        } else if (value.length < 6) {
                          return 'code_must_be_6_digits'.tr();
                        }
                        return null;
                      },
                      pinTheme: PinTheme(
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        activeFillColor: Colors.white,
                        activeColor: MyColors.MainBeerus,
                        inactiveColor: MyColors.MainBeerus,
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(16.0),
                        fieldHeight: MediaQuery.of(context).size.width / 7,
                        fieldWidth: MediaQuery.of(context).size.width / 7.6,
                      ),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.number,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        color: MyColors.MainZeno,
                        fontWeight: FontWeight.w600,
                      ),
                      onCompleted: (pin) async {},
                    ),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: _resendTimer > 0
                        ? null
                        : () async {
                      try {
                        final response = await Provider.of<Auth>(context, listen: false)
                            .sendOTPNew(phoneNumber: widget.phoneNumber);
                        if (response.status == ResponseStatus.success) {
                          startResendTimer();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'تم إعادة إرسال رمز التحقق',
                                style: TextStyle(color: Color(0xffEEEEEE)),
                              ),
                            ),
                          );

                        } else {

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Color(0xffBF3131),
                              content: Text(
                                response.errorMessage ?? 'حدث خطأ أثناء إرسال رمز التحقق',
                                style: TextStyle(color: Color(0xffEEEEEE)),
                              ),
                            ),
                          );

                        }
                      } catch (e) {

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Color(0xffBF3131),
                            content: Text(
                              'حدث خطأ أثناء إرسال رمز التحقق',
                              style: TextStyle(color: Color(0xffEEEEEE)),
                            ),
                          ),
                        );

                      } finally {

                      }
                          },
                    child: Text(
                      _resendTimer > 0
                          ? 'لم تستلم أي رمز؟ إعادة الإرسال $timerText'
                          : 'لم تستلم أي رمز؟ إعادة الإرسال',
                      style: TextStyle(
                        color: _resendTimer > 0 ? Colors.grey : MyColors.MainBulma,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!widget.isRegisterScreen)
                    LabelText(text: 'Password'.tr()),
                  if (!widget.isRegisterScreen) const SizedBox(height: 8),
                  if (!widget.isRegisterScreen) buildPasswordField(),
                  if (!widget.isRegisterScreen) const SizedBox(height: 16),
                  if (!widget.isRegisterScreen)
                    LabelText(text: 'Password Confirmation'.tr()),
                  if (!widget.isRegisterScreen) const SizedBox(height: 8),
                  if (!widget.isRegisterScreen) buildConfirmPasswordField(),
                  const SizedBox(height: 16),
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
                              if (pinOtp.length != 6) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'please_enter_verify_code'.tr())),
                                );
                                return;
                              }
                              setState(() {
                                _isLoading = true;
                              });
                              if (widget.isRegisterScreen) {
                                ResponseHandler response =
                                    await Provider.of<Auth>(context,
                                            listen: false)
                                        .verifyAccount(
                                  phoneNumber: widget.phoneNumber,
                                  otp: pinOtp,
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                                if (response.status == ResponseStatus.success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Account Has Been Verified Successfully'
                                                .tr())),
                                  );
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              context.read<Auth>().isProvider
                                                  ? TabsProviderScreen()
                                                  : TabsScreen()),
                                      (route) => false);
                                } else if (response.errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text(response.errorMessage!.tr())),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Error Occurred'.tr())),
                                  );
                                }
                              } else {
                                ResponseHandler response =
                                    await Provider.of<Auth>(context,
                                            listen: false)
                                        .forgotPasswordReset(
                                  phoneNumber: widget.phoneNumber,
                                  password: _passwordController.text,
                                  confirmPassword:
                                      _confirmPasswordController.text,
                                  otp: pinOtp,
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                                if (response.status == ResponseStatus.success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Password has been reset successfully'
                                                .tr())),
                                  );
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AuthScreen()),
                                      (route) => false);
                                } else if (response.errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text(response.errorMessage!.tr())),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Error Occurred'.tr())),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Continue'.tr(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                  SizedBox(height: 24),
                ],
              ),
            ),
            if (!widget.isRegisterScreen)
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

  Widget buildPasswordField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please_enter_password'.tr();
        }
        if (value.length < 6) {
          return 'password_must_be_at_least_6_characters'.tr();
        }
        return null;
      },
      maxLines: 1,
      controller: _passwordController,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        enabledBorder: InputBorders.enabledBorder,
        errorBorder: InputBorders.errorBorder,
        focusedBorder: InputBorders.focusedBorder,
        focusedErrorBorder: InputBorders.focusedErrorBorder,
        hintText: 'Password'.tr(),
        alignLabelWithHint: true,
        hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: MyColors.LightDark),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: MyColors.LightDark,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      obscureText: !_isPasswordVisible,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: MyColors.Darkest),
      keyboardType: TextInputType.visiblePassword,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  Widget buildConfirmPasswordField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please_enter_password'.tr();
        }
        if (value.length < 6) {
          return 'password_must_be_at_least_6_characters'.tr();
        }
        return null;
      },
      maxLines: 1,
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        enabledBorder: InputBorders.enabledBorder,
        errorBorder: InputBorders.errorBorder,
        focusedBorder: InputBorders.focusedBorder,
        focusedErrorBorder: InputBorders.focusedErrorBorder,
        hintText: 'Password Confirmation'.tr(),
        alignLabelWithHint: true,
        hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: MyColors.LightDark),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: MyColors.LightDark,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
      ),
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: MyColors.Darkest),
      keyboardType: TextInputType.text,
      obscureText: !_isConfirmPasswordVisible,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  Widget phoneNumber() {
    return TextFormField(
      readOnly: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: phoneController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please_enter_phone_number'.tr();
        }
        if (value.length < 10) {
          return 'phone_number_must_be_10_digits_at_minimum'.tr();
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
          borderSide:
              BorderSide(color: MyColors.MainBeerus, style: BorderStyle.solid),
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
        hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: MyColors.LightDark),
      ),
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: MyColors.Darkest),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10)
      ],
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
