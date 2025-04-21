import 'package:ajeer/constants/get_storage.dart';
import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:ajeer/controllers/general/wallet_provider_controller.dart';
import 'package:ajeer/ui/widgets/appbar_title.dart';
import 'package:ajeer/ui/widgets/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../constants/my_colors.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final String walletBalance = storage.read('wallet_provider') ?? "0.0";

  var _controller = TextEditingController();
  var _controller_Copon = TextEditingController();
  bool status = false;
  bool status_Copon = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  FutureBuilder(
                      future: WalletController().getWallet(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox();
                        } else if (snapshot.hasData) {
                          return Text(
                            "${snapshot.data.toString()} دينار",
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text("");
                        }
                      }),
                  SizedBoxedH12,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          status = !status;
                        });
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
                        "شحن المحفظة",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          status_Copon = !status_Copon;
                        });
                      },
                      child: Text(
                        "هل لديك كوبون خصم ؟ إضغط هنا",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
            SizedBoxedH24,
            Visibility(
              visible: status,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                status = !status;
                              });
                            },
                            icon: Icon(
                              Icons.close_rounded,
                            )),
                      ],
                    ),
                    const Text(
                      "قم بإدخال رقم الكوبون",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBoxedH12,
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _controller,
                        onChanged: (value) {},
                        readOnly: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                                color: Colors.red, style: BorderStyle.solid),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                                color: MyColors.MainBeerus,
                                style: BorderStyle.solid),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: MyColors.MainBeerus,
                              )),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                                color: Colors.red, style: BorderStyle.solid),
                          ),
                          hintText: 'xxxxx-xxxxx-xxxxx',
                          alignLabelWithHint: true,
                          hintStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: MyColors.LightDark),
                        ),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: MyColors.Darkest),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                          _PhoneNumberInputFormatter(),
                        ],
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                    ),
                    SizedBoxedH12,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_controller.text.isNotEmpty) {
                            var response = await WalletController.chargeWallet(
                                _controller.text);
                            if (response) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("تم الإشتراك بنجاح")));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("كود الكوبون غير متوفر")));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("الرجاء قم بتعبئة البيانات")));
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
                          "شحن",
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
            ),
            SizedBoxedH24,
            Visibility(
              visible: status_Copon,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                status_Copon = !status_Copon;
                              });
                            },
                            icon: Icon(
                              Icons.close_rounded,
                            )),
                      ],
                    ),
                    const Text(
                      "قم بإدخال رقم كوبون الخصم",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBoxedH12,
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _controller_Copon,
                        onChanged: (value) {},
                        readOnly: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                                color: Colors.red, style: BorderStyle.solid),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                                color: MyColors.MainBeerus,
                                style: BorderStyle.solid),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: MyColors.MainBeerus,
                              )),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                                color: Colors.red, style: BorderStyle.solid),
                          ),

                          alignLabelWithHint: true,
                          hintStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: MyColors.LightDark),
                        ),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: MyColors.Darkest),
                        keyboardType: TextInputType.name,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.digitsOnly,
                        //   LengthLimitingTextInputFormatter(15),
                        //   _PhoneNumberInputFormatter(),
                        // ],
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                    ),
                    SizedBoxedH12,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_controller_Copon.text.isNotEmpty) {
                            var response = await WalletController.chargeCopunForDiscount(
                                _controller_Copon.text);
                            if (response) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("تم الإشتراك بنجاح")));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("كود الكوبون غير متوفر")));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("الرجاء قم بتعبئة البيانات")));
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
                          "تأكيد",
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
            ),
          ],
        ),
      ),
    );
  }
}

// Custom TextInputFormatter that adds a hyphen after every 3 digits
class _PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Get the raw text without hyphens
    String text = newValue.text.replaceAll('-', '');

    // Add hyphens after every 3 characters
    StringBuffer formattedText = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      formattedText.write(text[i]);
      if ((i + 1) % 5 == 0 && i + 1 != text.length) {
        formattedText.write('-');
      }
    }

    // Return the new value with the formatted text
    return newValue.copyWith(
      text: formattedText.toString(),
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
