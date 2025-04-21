import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../constants/my_colors.dart';
import '../widgets/appbar_title.dart';
import '../widgets/button_styles.dart';
import '../widgets/input_decoration.dart';
import '../widgets/input_label.dart';
import '../widgets/sized_box.dart';
import '../widgets/title_section.dart';

class RequestServiceScreen extends StatelessWidget {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _secondPhoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _timeController = TextEditingController();
  final _offerImageController = TextEditingController();
  final _notesController = TextEditingController();

  RequestServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(title: 'حجز الخدمة'),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Divider(
            color: Colors.grey.withOpacity(0.1),
            thickness: 10,
          ),
          SizedBoxedH16,
          TitleSections(title: 'تفاصيل الخدمة', isViewAll: false, onTapView: () {}),
          SizedBoxedH16,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16, right: 8),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: 'https://mybayutcdn.bayut.com/mybayut/wp-content/uploads/AC-Malfunctions-_-Cover-ar24112022.jpg',
                          height: 120,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'فحص التكييف'.tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: MyColors.Darkest,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Card(
                                  color: MyColors.cardPriceBackgroundColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                    child: Text(
                                      '20 دينار',
                                      style: TextStyle(fontSize: 12, color: MyColors.MainPrimary),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBoxedH8,
                            Row(
                              children: [
                                SvgPicture.asset('assets/svg/request_calender.svg'),
                                const SizedBox(width: 6),
                                const Text(
                                  'بداية من 2/8/2024',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: MyColors.textColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBoxedH8,
                            Row(
                              children: [
                                SvgPicture.asset('assets/svg/request_calender.svg'),
                                const SizedBox(width: 6),
                                const Text(
                                  'حتي 10/8/2024',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: MyColors.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBoxedH16,
          Divider(
            color: Colors.grey.withOpacity(0.1),
            thickness: 6,
          ),
          SizedBoxedH16,
          TitleSections(title: 'مراجعة البيانات', isViewAll: false, onTapView: () {}),
          SizedBoxedH16,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                LabelText(text: 'اسم بالكامل'.tr()),
                SizedBoxedH8,
                TextFormField(
                  controller: _fullNameController,
                  decoration: buildInputDecoration(hintText: 'اسم بالكامل'.tr(), prefixIcon: const Icon(Icons.person)),
                ),
                SizedBoxedH16,
                LabelText(text: 'رقم الهاتف'.tr()),
                SizedBoxedH8,
                TextFormField(
                  controller: _phoneController,
                  decoration: buildInputDecoration(hintText: 'رقم الهاتف'.tr(), prefixIcon: const Icon(Icons.phone)),
                ),
                SizedBoxedH16,
                LabelText(text: 'رقم هاتف آخر'.tr()),
                SizedBoxedH8,
                TextFormField(
                  controller: _secondPhoneController,
                  decoration: buildInputDecoration(hintText: 'رقم هاتف آخر'.tr(), prefixIcon: const Icon(Icons.phone)),
                ),
                SizedBoxedH16,
                LabelText(text: 'العنوان'.tr()),
                SizedBoxedH8,
                TextFormField(
                  controller: _locationController,
                  decoration: buildInputDecoration(hintText: 'العنوان'.tr(), prefixIcon: const Icon(Icons.location_on)),
                ),
                SizedBoxedH16,
                LabelText(text: 'موعد التنفيذ'.tr()),
                SizedBoxedH8,
                TextFormField(
                  controller: _timeController,
                  decoration: buildInputDecoration(hintText: 'موعد التنفيذ'.tr(), prefixIcon: const Icon(Icons.calendar_month_outlined)),
                ),
                SizedBoxedH16,
                LabelText(text: 'صور المشكلة'.tr()),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _offerImageController,
                  decoration: buildInputDecoration(hintText: 'صور المشكلة'.tr()),
                  readOnly: true,
                ),
                SizedBoxedH16,
                LabelText(text: 'ملاحظات'.tr()),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  decoration: buildInputDecoration(hintText: 'ملاحظات'.tr()),
                ),
              ],
            ),
          ),
          SizedBoxedH16,
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: TextButton(
                style: flatButtonPrimaryStyle,
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestServiceScreen()));
                },
                child: Text(
                  'حجز الخدمة'.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBoxedH16,
        ],
      ),
    );
  }
}
