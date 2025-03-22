import 'package:ajeer/constants/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AppbarTitle extends StatelessWidget implements PreferredSizeWidget {
  String title;
  bool haveAddBtn;
  VoidCallback? addBtnOnPressed;

  AppbarTitle({
    super.key,
    required this.title,
    this.haveAddBtn = false,
    this.addBtnOnPressed = null,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16), //adjust the padding as you want
      child: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset('assets/svg/back_appbar.svg'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          title.tr(),
          style: const TextStyle(
            color: MyColors.Darkest,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: haveAddBtn
            ? [
                IconButton(
                  icon: SvgPicture.asset('assets/svg/appbar_add_btn.svg'),
                  onPressed: addBtnOnPressed,
                ),
              ]
            : null,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ), //or row/any widget
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
