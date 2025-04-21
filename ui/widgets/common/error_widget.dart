import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

Widget errorWidget(BuildContext context) {
  return Center(
    child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/error_widget.svg',
              height: 200,
            ),
            const SizedBox(height: 20),
            Text("Ops, Something went wrong".tr()),
          ],
        )),
  );
}
