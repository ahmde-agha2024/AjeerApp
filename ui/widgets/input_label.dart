import 'package:flutter/material.dart';

import '../../../constants/my_colors.dart';

class LabelText extends StatelessWidget {
  final String text;

  const LabelText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: MyColors.Darkest),
        ),
      ],
    );
  }
}
