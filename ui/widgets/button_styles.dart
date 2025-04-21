import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    backgroundColor: MyColors.Darkest,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ));

final ButtonStyle flatButtonPrimaryStyle = TextButton.styleFrom(
    disabledBackgroundColor: Colors.grey,
    backgroundColor: MyColors.MainBulma,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ));

final ButtonStyle flatButtonLightStyle = TextButton.styleFrom(
    backgroundColor: MyColors.MainGoku,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ));

final ButtonStyle flatButtonDisabledStyle = TextButton.styleFrom(
    backgroundColor: Colors.grey.shade600,
    foregroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ));

final ButtonStyle flatButtonDoneStyle = TextButton.styleFrom(
    backgroundColor: MyColors.SupportiveRoshi,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ));

final ButtonStyle flatButtonGreyStyle = TextButton.styleFrom(
    backgroundColor: MyColors.MainGoku,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ));

final ButtonStyle flatButtonContinueStyle = TextButton.styleFrom(
    backgroundColor: MyColors.MainBulma,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ));
