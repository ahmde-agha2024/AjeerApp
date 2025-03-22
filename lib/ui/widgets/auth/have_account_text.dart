import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../constants/my_colors.dart';

class HaveAccountText extends StatelessWidget {
  const HaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, authProvider, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                authProvider.isLoginScreen ? 'Dont have an account ?'.tr() : 'Already have an account ? '.tr(),
                style: const TextStyle(
                  color: MyColors.Darkest,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 2),
              InkWell(
                onTap: () {
                  authProvider.changeIsLoginScreen(!authProvider.isLoginScreen);
                },
                child: Text(
                  authProvider.isLoginScreen ? 'New registration'.tr() : 'Login'.tr(),
                  style: const TextStyle(
                    color: MyColors.MainBulma,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
