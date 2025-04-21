import 'package:ajeer/constants/get_storage.dart';
import 'package:ajeer/controllers/general/wallet_provider_controller.dart';
import 'package:ajeer/ui/widgets/appbar_title.dart';
import 'package:ajeer/ui/widgets/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../constants/my_colors.dart';

class WalletPaymentScreen extends StatefulWidget {
  WalletPaymentScreen({super.key, required this.package_id});

  int package_id;

  @override
  State<WalletPaymentScreen> createState() => _WalletPaymentScreenState();
}

class _WalletPaymentScreenState extends State<WalletPaymentScreen> {
  final String walletBalance = storage.read('wallet_provider') ?? "0.0";
  bool status = false;
  WalletController _walletController = WalletController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(title: 'المحفظة'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    " رصيد المحفظة",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBoxedW8,
                  Text(
                    "$walletBalance دينار",
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBoxedH12,
                ],
              ),
            ),
            SizedBoxedH24,
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "تأكيد عملية الشراء",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBoxedH12,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        var response = await WalletController.BuyWithWallet(
                            packageId: widget.package_id);
                        if (response) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("تم الشراء بنجاح")));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "رصيدك الحالي لا يكفي للقيام بعملية الشراء")));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Set border radius here
                        ),
                      ),
                      child: const Text(
                        "شراء",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
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

// Transaction Tile Widget
