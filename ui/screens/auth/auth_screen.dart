import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/auth/card_opactiy_header.dart';
import '../../widgets/auth/client_or_provider_tabs.dart';
import '../../widgets/auth/have_account_text.dart';
import '../../widgets/auth/header_auth.dart';
import '../../widgets/auth/header_text.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, authProvider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Stack(
              children: [
                const HeaderAuth(),
                // const CardOpacityHeader(),
                Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    Expanded(
                      child: Card(
                        margin: EdgeInsets.zero,
                        clipBehavior: Clip.antiAlias,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const HeaderTextLoginOrRegister(),
                                const ClientOrProviderTabs(),
                                if (authProvider.isLoginScreen) const LoginScreen(),
                                if (!authProvider.isLoginScreen) const RegisterScreen(),
                                const HaveAccountText(),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
