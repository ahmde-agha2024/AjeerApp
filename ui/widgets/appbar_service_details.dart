import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppbarServiceDetails extends StatelessWidget {
  const AppbarServiceDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset('assets/svg/bookmark_services_details.svg'),
        InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset('assets/svg/back_btn_services_details.svg')),
      ],
    );
  }
}
