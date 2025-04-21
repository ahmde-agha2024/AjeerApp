import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../bussiness/connectivity_provider.dart';
import '../../constants/my_colors.dart';

class NoInternetScreen extends StatelessWidget {
  final Widget child;
  NoInternetScreen({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isConnected = context.watch<ConnectivityProvider>().isConnected;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: translator.delegates,
      supportedLocales: translator.locals(),
      home: Scaffold(
        body: Stack(
          children: [
            child,
            if (!isConnected)
              Container(
                color: Colors.white.withOpacity(0.92),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.wifi_off,
                          size: 70,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'No Internet Connection'.tr(),
                          style: TextStyle(fontSize: 22),
                        ),
                        const SizedBox(height: 12),
                        Text(
                            'Sorry, You cant use this page without an internet connection'
                                .tr()),
                        const SizedBox(height: 4),
                        TextButton(
                          onPressed: () async {
                            // switch (OpenSettingsPlus.shared) {
                            //   OpenSettingsPlusAndroid settings => settings.wifi(),
                            //   OpenSettingsPlusIOS settings => settings.wifi(),
                            //   _ => throw Exception('Platform not supported'),
                            // }
                          },
                          child: Text(
                            'Retry'.tr(),
                            style: const TextStyle(
                              color: MyColors.MainPrimary,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
