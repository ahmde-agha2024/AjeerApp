import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../constants/my_colors.dart';

class HeaderTextLoginOrRegister extends StatelessWidget {
  const HeaderTextLoginOrRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, authProvider, child) {
        return Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025, bottom: MediaQuery.of(context).size.height * 0.01),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    authProvider.isLoginScreen ? 'Log'.tr() : 'Welcome'.tr(),
                    style: const TextStyle(
                      color: MyColors.Darkest,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    authProvider.isLoginScreen ? 'In'.tr() : 'With Ajeer'.tr(),
                    style: const TextStyle(
                      color: MyColors.MainBulma,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  authProvider.isLoginScreen ? 'Log in now and enjoy Ajeers distinguished services'.tr() : 'Fill in the required data to complete the account creation process.'.tr(),
                  style: const TextStyle(
                    color: MyColors.SubTitleHeaderColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
