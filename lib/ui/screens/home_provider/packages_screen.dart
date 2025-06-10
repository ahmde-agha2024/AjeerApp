import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:ajeer/controllers/service_provider/provider_subscriptions_provider.dart';
import 'package:ajeer/models/provider/provider_subscriptions_model.dart';
import 'package:ajeer/ui/screens/edit_profile_screen.dart';
import 'package:ajeer/ui/screens/home_provider/waleetScreens/walletShowScreens.dart';
import 'package:ajeer/ui/screens/home_provider/waleetScreens/walletpaymentScreens.dart';
import 'package:ajeer/ui/screens/payment_webview.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/my_colors.dart';
import '../../widgets/appbar_title.dart';
import '../../widgets/auth/plan_card.dart';
import '../../widgets/button_styles.dart';
import '../../widgets/sized_box.dart';
import '../../widgets/title_section.dart';
import '../faq_screen.dart';
import '../terms_and_conditions_screen.dart';

class PackagesScreen extends StatefulWidget {
  PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  bool _isDataLoaded = false;
  bool _isAgree = false;
  bool _isSubscibing = false;
  ResponseHandler<List<ProviderSubscriptionPackage>>? subscriptions;
  ProviderSubscriptionPackage? _selectedPlan;

  @override
  void didChangeDependencies() {
    if (!_isDataLoaded) {
      Provider.of<ProviderSubscriptions>(context, listen: false)
          .fetchAvailablePackages()
          .then((value) {
        setState(() {
          subscriptions = value;
          _isDataLoaded = true;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(
        title: 'الباقات',
      ),
      backgroundColor: Colors.white,
      body: !_isDataLoaded
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "اختر الباقة المناسبة لك",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // عدد الأعمدة في الشبكة
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: 4, // عدد البطاقات
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: 100,
                                  height: 20,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
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
          : subscriptions!.status == ResponseStatus.error
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
                              _isDataLoaded = false;
                              didChangeDependencies();
                            });
                          }),
                    )
                  ],
                )
              : ListView(
                  children: [
                    Divider(
                      color: Colors.grey.withOpacity(0.1),
                      thickness: 10,
                    ),
                    SizedBoxedH32,
                    TitleSections(
                      title: 'اختر الباقة المناسبة لك ',
                      isViewAll: false,
                      onTapView: () {},
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 2),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 210,
                      ),
                      itemCount: subscriptions!.response!.length,
                      itemBuilder: (context, index) {
                        return PlanCard(
                          planIndex: index,
                          svgAsset: 'assets/svg/bronze_plan.svg',
                          planName: subscriptions!.response![index].title!,
                          requests:
                              '${subscriptions!.response![index].offers.toString()} طلب',
                          price:
                              '${subscriptions!.response![index].price.toString()} دينار ليبيي',
                          // make them colored one and one
                          // color: (index % 2 == (index ~/ 2) % 2)
                          //     ? MyColors.MainZeno
                          //     : MyColors.MainBulma,
                          color: index==0?MyColors.MainZeno:index==1?const Color(0xff606C5D):Color(0xffEF962D),
                          isSelected: _selectedPlan?.id! ==
                              subscriptions!.response![index].id!,
                          onTap: () {
                            setState(() {
                              _selectedPlan = subscriptions!.response![index];
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _isAgree,
                            onChanged: (bool? value) {
                              setState(() {
                                _isAgree = value ?? false;
                              });
                            },
                            activeColor: MyColors.MainBulma,
                          ),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                text:
                                    'By registering with us you agree to '.tr(),
                                style: const TextStyle(color: MyColors.Darkest),
                                children: [
                                  TextSpan(
                                    text: 'Terms and Conditions'.tr(),
                                    style: const TextStyle(
                                        color: MyColors.MainBulma,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const TermsAndConditionsScreen()));
                                      },
                                  ),
                                  TextSpan(
                                      text: ' and '.tr(),
                                      style: const TextStyle(
                                          color: MyColors.Darkest)),
                                  TextSpan(
                                    text: 'privacy policy'.tr(),
                                    style: const TextStyle(
                                        color: MyColors.MainBulma,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FaqScreen()));
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 64),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _isSubscibing
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: TextButton(
                                style: flatButtonPrimaryStyle,
                                onPressed: _selectedPlan == null ||
                                        _isSubscibing
                                    ? null
                                    : () async {
                                        // showModalBottomSheet(
                                        //   context: context,
                                        //   builder: (context) {
                                        //     return const PaymentMethodBottomSheet();
                                        //   },
                                        //   shape: const RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                        //   ),
                                        //   isScrollControlled: true, // للتحكم في حجم البوتوم شيت
                                        // );
                                        // if (context
                                        //         .read<Auth>()
                                        //         .provider!
                                        //         .email ==
                                        //     null) {
                                        //   ScaffoldMessenger.of(context)
                                        //       .showSnackBar(SnackBar(
                                        //           content: Text(
                                        //               'يجب عليك تحديث بريدك الإلكتروني أولا'
                                        //                   .tr()))); // TODO TRANSLATE
                                        //   Navigator.of(context).push(
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               EditProfileScreen()));
                                        //   return;
                                        // }

                                        if (!_isAgree) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'يجب عليك الموافقة على الشروط والأحكام أولا'
                                                          .tr()))); // TODO TRANSLATE
                                          return;
                                        }
                                        setState(() {
                                          _isSubscibing = true;
                                        });
                                        ResponseHandler<String> response =
                                            await Provider.of<
                                                        ProviderSubscriptions>(
                                                    context,
                                                    listen: false)
                                                .subscribeToAPackage(
                                                    packageId:
                                                        _selectedPlan!.id!);
                                        setState(() {
                                          _isSubscibing = false;
                                        });
                                        if (!context.mounted) {
                                          return;
                                        }
                                        if (response.status ==
                                            ResponseStatus.success) {
print(response.response!);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SubscriptionPaymentScreen(
                                                        selectedUrl:
                                                            response.response!,
                                                      )));
                                        } else if (response.errorMessage !=
                                            null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      response.errorMessage!)));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Error Occurred'.tr())));
                                        }
                                      },
                                child: Text(
                                  'اشترك الان${_selectedPlan != null ? ' ب ${_selectedPlan!.price!} دينار' : ''}'
                                      .tr(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _isSubscibing
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: TextButton(
                                style: flatButtonPrimaryStyle,
                                onPressed: _selectedPlan == null ||
                                        _isSubscibing
                                    ? null
                                    : () async {
                                        // if (context
                                        //         .read<Auth>()
                                        //         .provider!
                                        //         .email ==
                                        //     null) {
                                        //   ScaffoldMessenger.of(context)
                                        //       .showSnackBar(SnackBar(
                                        //           content: Text(
                                        //               'يجب عليك تحديث بريدك الإلكتروني أولا'
                                        //                   .tr()))); // TODO TRANSLATE
                                        //   Navigator.of(context).push(
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               EditProfileScreen()));
                                        //   return;
                                        // }
                                        if (!_isAgree) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'يجب عليك الموافقة على الشروط والأحكام أولا'
                                                          .tr()))); // TODO TRANSLATE
                                          return;
                                        }
                                        setState(() {
                                          _isSubscibing = true;
                                        });
                                        ResponseHandler<String> response =
                                            await Provider.of<
                                                        ProviderSubscriptions>(
                                                    context,
                                                    listen: false)
                                                .subscribeToAPackage(
                                                    packageId:
                                                        _selectedPlan!.id!);
                                        setState(() {
                                          _isSubscibing = false;
                                        });
                                        if (!context.mounted) {
                                          return;
                                        }
                                        if (response.status ==
                                            ResponseStatus.success) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WalletPaymentScreen(
                                                        package_id:
                                                            _selectedPlan!.id!,
                                                      )));
                                        } else if (response.errorMessage !=
                                            null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      response.errorMessage!)));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Error Occurred'.tr())));
                                        }

                                      },
                                child: const Text(
                                  'الإشتراك عن طريق المحفظة',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }
}
