import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppbarAuth extends StatelessWidget implements PreferredSizeWidget {
  const AppbarAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16), //adjust the padding as you want
      child: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset('assets/svg/back_appbar.svg'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Image.asset('assets/Icons/logo_app.png'),
        ],
      ), //or row/any widget
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
