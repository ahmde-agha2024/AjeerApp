import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

void showReportToast() {
  Fluttertoast.showToast(
    msg: "A report has been made to the admin and will be reviewed.".tr(),
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void showReportToAdmin(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: ListTile(
          leading: const Icon(Icons.report, color: Colors.red),
          title: Text('Report to Admin'.tr()),
          onTap: () {
            Navigator.of(context).pop();
            showReportToast();
          },
        ),
      );
    },
  );
}
