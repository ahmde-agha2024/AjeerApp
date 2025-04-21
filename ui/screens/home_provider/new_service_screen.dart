import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../widgets/appbar_title.dart';
import '../../widgets/button_styles.dart';
import '../../widgets/input_decoration.dart';
import '../../widgets/input_label.dart';
import '../../widgets/sized_box.dart';

class NewServiceScreen extends StatelessWidget {
  const NewServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(
        title: 'إضافة خدمة',
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Divider(
            color: Colors.grey.withOpacity(0.1),
            thickness: 10,
          ),
          SizedBoxedH32,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                LabelText(text: 'اسم الخدمة : '.tr()),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: buildInputDecoration(hintText: 'اسم الخدمة'.tr()),
                ),
                const SizedBox(height: 16),
                LabelText(text: 'التصنيف'.tr()),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: buildInputDecoration(hintText: 'التصنيف'.tr()),
                  items: ['Option 1', 'Option 2', 'Option 3'].map((e) => DropdownMenuItem<String>(child: Text(e), value: e)).toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                LabelText(text: 'سعر الخدمة : '.tr()),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: buildInputDecoration(hintText: 'سعر الخدمة'.tr()),
                ),
                const SizedBox(height: 16),
                LabelText(text: 'صور الخدمة : '.tr()),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: buildInputDecoration(hintText: 'صور الخدمة'.tr()),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: TextButton(
                    style: flatButtonPrimaryStyle,
                    onPressed: () {},
                    child: Text(
                      'حفظ التغييرات'.tr(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () async {},
                    child: Text(
                      'حذف التغييرات'.tr(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
