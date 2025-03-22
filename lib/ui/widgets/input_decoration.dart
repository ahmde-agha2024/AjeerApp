// input_styles.dart

import 'package:flutter/material.dart';

import '../../../constants/my_colors.dart';

InputDecoration buildInputDecoration({required String hintText, Icon? prefixIcon}) {
  return InputDecoration(
    border: OutlineInputBorder(),
    prefixIcon: prefixIcon,
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(color: MyColors.MainBeerus, style: BorderStyle.solid),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(color: MyColors.MainBeerus, style: BorderStyle.solid),
    ),
    fillColor: Colors.white,
    filled: true,
    hintText: hintText,
    hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: MyColors.LightDark),
  );
}

class InputBorders {
  static OutlineInputBorder get enabledBorder {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(color: MyColors.MainBeerus, style: BorderStyle.solid),
    );
  }

  static OutlineInputBorder get errorBorder {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Colors.red, style: BorderStyle.solid),
    );
  }

  static OutlineInputBorder get focusedBorder {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: MyColors.MainBeerus, style: BorderStyle.solid),
    );
  }

  static OutlineInputBorder get focusedErrorBorder {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Colors.red, style: BorderStyle.solid),
    );
  }
}
