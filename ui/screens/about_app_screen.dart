import 'package:ajeer/constants/my_colors.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/general/about_app_controller.dart';
import 'package:ajeer/models/general/about_app_model.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/rendering.dart';

import '../widgets/appbar_title.dart';
import '../widgets/button_styles.dart';
import '../widgets/sized_box.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  bool _isFetched = false;
  ResponseHandler<AboutAppModel> aboutApp =
      ResponseHandler(status: ResponseStatus.error);

  @override
  void didChangeDependencies() {
    if (!_isFetched) {
      Provider.of<AboutApp>(context, listen: false)
          .fetchAboutApp()
          .then((value) {
        setState(() {
          aboutApp = value;
          _isFetched = true;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(title: 'عن التطبيق'),
      backgroundColor: Colors.white,
      body: !_isFetched
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // اللوجو
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 150,
                      height: 100,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                  // النص الوصفي
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                  // أيقونات التواصل الاجتماعي
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 30),

                  // معلومات الاتصال (الإيميل والهاتف)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildShimmerBox(),
                      SizedBox(width: 10),
                      _buildShimmerBox(),
                    ],
                  ),
                  SizedBox(height: 20),

                  // زر "تواصل معنا"
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : aboutApp.status == ResponseStatus.error
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    errorWidget(context),
                    Builder(
                      builder: (context) => MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          color: MyColors.MainBulma,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            child: Text(
                              'Try Again'.tr(), // TODO TRANSLATE
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _isFetched = false;
                              didChangeDependencies();
                            });
                          }),
                    )
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    children: [
                      Divider(
                        color: Colors.grey.withOpacity(0.1),
                        thickness: 10,
                      ),
                      SizedBoxedH16,
                      Image.asset('assets/Icons/logo.png',width: 204,height: 93,),
                      SizedBoxedH16,

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SvgPicture.asset('assets/svg/linked.svg'),
                          // SizedBoxedW8,
                          // SvgPicture.asset('assets/svg/youtube.svg'),
                          // SizedBoxedW8,
                          Image.asset('assets/Icons/facebook.png',width: 32,height: 32,),
                          SizedBoxedW8,
                          SvgPicture.asset('assets/svg/instagram.svg'),
                          SizedBoxedW8,
                          Image.asset('assets/Icons/tiktok.png',width: 32,height: 32,),

                        ],
                      ),
                      SizedBoxedH32,
                      const Text(
                        'نحن هنا دائما لدعمك وتلبية إحتياجك، لذا لا تترد في الإتصال بنا إذا  كان هناك أي شئ نستطيع مساعدتك به .',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBoxedH16,
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  launch('tel:${aboutApp.response!.phone}');
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/svg/aboutus_phone.svg'),
                                      SizedBoxedH8,
                                      Text(
                                        aboutApp.response!.phone!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  print(aboutApp.response!.email);
                                  final Uri emailUri = Uri(
                                    scheme: 'mailto',
                                    path: aboutApp.response!.email,
                                  );

                                  // Check if the email URL can be launched
                                  if (await canLaunchUrl(emailUri)) {
                                    await launchUrl(emailUri);
                                  } else {
                                    throw 'Could not launch $emailUri';
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/svg/aboutus_email.svg'),
                                      SizedBoxedH8,
                                      Text(
                                        aboutApp.response!.email!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBoxedH32,
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: TextButton(
                          style: flatButtonPrimaryStyle,
                          onPressed: () {
                            launch('tel:${aboutApp.response!.phone}');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/svg/aboutUs_contant.svg'),
                              SizedBoxedW8,
                              Text(
                                'تواصل معنا'.tr(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBoxedH16,
                      SizedBoxedH16,
                    ],
                  ),
                ),
    );
  }

  Widget _buildShimmerBox() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 140,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
