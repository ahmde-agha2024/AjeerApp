import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../constants/my_colors.dart';

//ignore: must_be_immutable
class TitleSections extends StatelessWidget {
  var title = '';
  bool isViewAll = false;
  VoidCallback onTapView;

  TitleSections({
    super.key,
    required this.title,
    this.isViewAll = false,
    required this.onTapView,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                  width: 2,
                  height: 24,
                  decoration: BoxDecoration(
                    color: MyColors.MainBulma,
                    border: Border.all(color: MyColors.MainBulma, width: 2),
                  )),
              const SizedBox(width: 8),
              Text(
                '${title}'.tr(),
                style: const TextStyle(
                  color: MyColors.Darkest,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          isViewAll
              ? InkWell(
                  onTap: onTapView,
                  child: Text(
                    'View All'.tr(),
                    style: const TextStyle(
                      color: MyColors.MainBulma,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
