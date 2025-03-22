import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../constants/my_colors.dart';

class ClientOrProviderTabs extends StatelessWidget {
  const ClientOrProviderTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, authProvider, child) {
        return Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          color: MyColors.cardBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      authProvider.changeToClientOrProvider(true);
                    },
                    splashColor: MyColors.cardBackgroundColor,
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: authProvider.isClient
                          ? Card(
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  'Client'.tr(),
                                ),
                              ))
                          : Center(
                              child: Text(
                                'Client'.tr(),
                              ),
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      authProvider.changeToClientOrProvider(false);
                    },
                    splashColor: MyColors.cardBackgroundColor,
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: !authProvider.isClient
                          ? Card(
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  'Service Provider'.tr(),
                                ),
                              ))
                          : Center(
                              child: Text(
                                'Service Provider'.tr(),
                              ),
                            ),
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
}
