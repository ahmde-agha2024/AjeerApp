import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:ajeer/ui/screens/auth/verify_code_password_screen.dart';
import 'package:ajeer/ui/screens/home_provider/tabs_provider_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../constants/my_colors.dart';
import '../../widgets/button_styles.dart';
import '../home_client/tabs_screen.dart';
import 'reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, authProvider, child) {
        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Phone Number'.tr(),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: MyColors.Darkest),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                phoneNumber(),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Text(
                      'Password'.tr(),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: MyColors.Darkest),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
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
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                          color: Colors.red, style: BorderStyle.solid),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                          color: MyColors.MainBeerus, style: BorderStyle.solid),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: MyColors.MainBeerus,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                          color: Colors.red, style: BorderStyle.solid),
                    ),
                    hintText: 'Password'.tr(),
                    alignLabelWithHint: true,
                    hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: MyColors.LightDark),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: MyColors.LightDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: MyColors.Darkest),
                  keyboardType: TextInputType.text,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ResetPasswordScreen()));
                      },
                      child: Text(
                        'Forget Password ? '.tr(),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: MyColors.MainBulma),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              ResponseHandler response =
                                  ResponseHandler(status: ResponseStatus.error);
                              if (authProvider.isClient &&
                                  !authProvider.isProvider) {
                                // login as customer
                                response = await Provider.of<Auth>(context,
                                        listen: false)
                                    .loginAsCustomer(
                                  phoneNumber: phoneController.text,
                                  password: passwordController.text,
                                );
                              } else if (!authProvider.isClient &&
                                  authProvider.isProvider) {
                                // login as provider
                                response = await Provider.of<Auth>(context,
                                        listen: false)
                                    .loginAsProvider(
                                  phoneNumber: phoneController.text,
                                  password: passwordController.text,
                                );
                              }
                              setState(() {
                                _isLoading = false;
                              });
                              if (response.status == ResponseStatus.success) {
                                if (authProvider.isClient &&
                                    !authProvider.isProvider) {
                                  // login as customer
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => TabsScreen()),
                                      (route) => false);
                                } else if (!authProvider.isClient &&
                                    authProvider.isProvider) {
                                  // login as provider
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TabsProviderScreen()),
                                      (route) => false);
                                }
                              } else if (response.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Color(0xffBF3131),
                                      content: Text(
                                        response.errorMessage!,
                                        style:
                                            TextStyle(color: Color(0xffEEEEEE)),
                                      )),
                                );
                                if (response.errorMessage ==
                                        'لم يتم تفعيل حسابك' &&
                                    context.mounted) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await Provider.of<Auth>(context,
                                          listen: false)
                                      .sendOTP(
                                          phoneNumber: phoneController.text);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          VerifyCodePasswordScreen(
                                            phoneNumber: phoneController.text,
                                            isRegisterScreen: true,
                                          )));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Color(0xffBF3131),

                                      content: Text("حاول مرة أخرى",style: TextStyle(
                                          color: Color(0xffEEEEEE)
                                      ),)),
                                );
                              }
                            }
                          },
                    child: _isLoading
                        ? const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Login'.tr(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
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
