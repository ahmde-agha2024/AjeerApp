import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/customer/home/customer_home_page_provider.dart';
import 'package:ajeer/models/customer/service_provider_details_model.dart';
import 'package:ajeer/ui/screens/service_request_add.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/my_colors.dart';
import '../../controllers/general/review_pass_provider.dart';
import '../widgets/appbar_backonly_transparent.dart';
import '../widgets/background_profile_stack.dart';
import '../widgets/profile_image_provider.dart';
import '../widgets/show_report_to_admin.dart';
import '../widgets/title_section.dart';

class ProviderDetailsScreen extends StatefulWidget {
  final int providerId;

  const ProviderDetailsScreen({super.key, required this.providerId});

  @override
  State<ProviderDetailsScreen> createState() => _ProviderDetailsScreenState();
}

class _ProviderDetailsScreenState extends State<ProviderDetailsScreen> {
  ResponseHandler<ServiceProviderDetails>? serviceProviderDetails;
  bool _isFetched = false;

  @override
  void didChangeDependencies() {
    Provider.of<CustomerHomeProvider>(context, listen: false)
        .fetchServiceProviderDetails(providerId: widget.providerId)
        .then((value) {
      setState(() {
        _isFetched = true;
        if (value.status == ResponseStatus.success) {
          serviceProviderDetails = value;
        }
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isFetched
          ? loaderWidget(context)
          : serviceProviderDetails == null
              ? errorWidget(context)
              : serviceProviderDetails?.status == ResponseStatus.error
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
                  : Stack(
                      children: [
                        const BackgroundProfileStack(),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2),
                              Stack(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.10),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Card(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // InkWell(
                                                      //   onTap: () {
                                                      //     // LaunchMode
                                                      //     launchUrl(Uri.parse(
                                                      //         'tel:${serviceProviderDetails!.response!.phone}'));
                                                      //   },
                                                      //   child: SvgPicture.asset(
                                                      //       'assets/svg/call_provider.svg'),
                                                      // ),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (
                                                                      context) =>
                                                                      ServiceRequestScreen(
                                                                        provider_id: serviceProviderDetails!
                                                                            .response
                                                                            !.id,)));
                                                        },
                                                        child: Icon(
                                                          Icons.outbond,
                                                          color: MyColors
                                                              .MainBulma,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Provider.of<ReviewPass>(
                                                                  context,
                                                                  listen: false)
                                                              .isAppleReview
                                                          ? InkWell(
                                                              child: const Icon(
                                                                Icons.list,
                                                                color: MyColors
                                                                    .MainBulma,
                                                              ),
                                                              onTap: () {
                                                                showReportToAdmin(
                                                                    context);
                                                              },
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08),
                                                Center(
                                                  child: Text(
                                                    serviceProviderDetails!
                                                        .response!.name!,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Center(
                                                  child: Text(
                                                    serviceProviderDetails!
                                                            .response!
                                                            .subcategories
                                                            ?.map((element) =>
                                                                element.title)
                                                            .join(' - ') ??
                                                        'N/A',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                Card(
                                                  elevation: 0,
                                                  color: serviceProviderDetails!
                                                              .response!
                                                              .status ==
                                                          1
                                                      ? MyColors
                                                          .CardBackgroundActive
                                                      : MyColors
                                                          .CardBackgroundInActive,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 8),
                                                    child: Text(
                                                      serviceProviderDetails!
                                                                  .response!
                                                                  .status ==
                                                              1
                                                          ? 'نشط'
                                                          : 'غير نشط',
                                                      style: TextStyle(
                                                        color: serviceProviderDetails!
                                                                    .response!
                                                                    .status ==
                                                                1
                                                            ? MyColors
                                                                .CardBackgroundActiveText
                                                            : MyColors
                                                                .CardBackgroundInActiveText,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                              'assets/svg/provider_stars.svg'),
                                                          const SizedBox(
                                                              height: 8),
                                                          Text(
                                                            '+${serviceProviderDetails!.response!.experience}',
                                                            style: const TextStyle(
                                                                color: MyColors
                                                                    .Darkest,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          const Text(
                                                            'سنوات الخبرة',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                              'assets/svg/provider_profile.svg'),
                                                          const SizedBox(
                                                              height: 8),
                                                          Text(
                                                            serviceProviderDetails!
                                                                    .response!
                                                                    .customers
                                                                    ?.toString() ??
                                                                'N/A',
                                                            style: const TextStyle(
                                                                color: MyColors
                                                                    .Darkest,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          const Text(
                                                            'عميل',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                              'assets/svg/provider_rate.svg'),
                                                          const SizedBox(
                                                              height: 8),
                                                          Text(
                                                            serviceProviderDetails!
                                                                    .response!
                                                                    .rate
                                                                    ?.length
                                                                    .toString() ??
                                                                'N/A',
                                                            style: const TextStyle(
                                                                color: MyColors
                                                                    .Darkest,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          const Text(
                                                            'تقييم',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                Divider(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  thickness: 10,
                                                ),
                                                const SizedBox(height: 16),
                                                TitleSections(
                                                    title: 'نبذة عن',
                                                    isViewAll: false,
                                                    onTapView: () {}),
                                                const SizedBox(height: 8),
                                                Text(
                                                  serviceProviderDetails!
                                                          .response!.about ??
                                                      'about is empty',
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 16),
                                                Divider(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  thickness: 10,
                                                ),
                                                const SizedBox(height: 16),
                                                TitleSections(
                                                    title: 'أخر الاعمال',
                                                    isViewAll: false,
                                                    onTapView: () {}),
                                                const SizedBox(height: 8),
                                                SizedBox(
                                                  height: 80,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        serviceProviderDetails!
                                                                .response!
                                                                .work!
                                                                .length ??
                                                            0,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                serviceProviderDetails!
                                                                    .response!
                                                                    .work![
                                                                        index]
                                                                    .image,
                                                            width: 80,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 0,
                                    left: 0,
                                    top: 0,
                                    child: Column(
                                      children: [
                                        ProfileImageProvider(
                                          profileImageUrl:
                                              serviceProviderDetails!
                                                  .response!.image!,
                                          isActive: serviceProviderDetails!
                                                  .response!.status ==
                                              1,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const AppbarBackonlyTransparent(),
                      ],
                    ),
    );
  }
}
