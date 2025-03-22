import 'package:flutter/material.dart';

class HeaderAuth extends StatelessWidget {
  const HeaderAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            child: FittedBox(fit: BoxFit.fill, child: Image.asset('assets/Icons/background_login.png', fit: BoxFit.fill)),
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
          child: Opacity(
            opacity: 0.8,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.37,
              width: MediaQuery.of(context).size.width,
              child: FittedBox(fit: BoxFit.fill, child: Image.asset('assets/Icons/gradient_login.png', fit: BoxFit.fill)),
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: MediaQuery.of(context).size.height * 0.1,
          left: 0,
          right: 0,
          child: Image.asset('assets/Icons/logo_login.png',scale: .8,),
        ),
      ],
    );
  }
}
