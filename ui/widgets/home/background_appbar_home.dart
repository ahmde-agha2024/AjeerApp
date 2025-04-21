import 'package:flutter/material.dart';

import '../../../constants/my_colors.dart';

class BackgroundAppbarHome extends StatelessWidget {
  String imageAssetPath;
  double opacityFrom;
  double opacityTo;
  double? height;
  double? width;

  BackgroundAppbarHome({
    super.key,
    required this.imageAssetPath,
    this.opacityFrom = 0.8,
    this.opacityTo = 0.8,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: height,
          width: width,
          child: Image.asset(
            imageAssetPath,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, colors: [
                MyColors.backgroundHomeGradiantStart.withOpacity(opacityFrom),
                MyColors.backgroundHomeGradiantEnd.withOpacity(opacityTo),
              ], stops: const [
                0.0,
                1.0
              ])),
        )
      ],
    );
  }
}
