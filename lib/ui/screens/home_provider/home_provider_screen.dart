import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/service_provider/provider_home_page_provider.dart';
import 'package:ajeer/controllers/service_provider/provider_services_provider.dart';
import 'package:ajeer/models/customer/home/home_model.dart' show CustomerHome;
import 'package:ajeer/models/customer/service_model.dart';
import 'package:ajeer/models/customer/service_provider_model.dart';
import 'package:ajeer/models/provider/home/provider_home_model.dart';
import 'package:ajeer/ui/screens/home_provider/packages_screen.dart'
    show PackagesScreen;
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:ajeer/ui/widgets/home/carousel_slider_home.dart'
    show CarouselSliderHome;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../NewDesign/blue_Provider.dart';
import '../../../NewDesign/plans.dart';
import '../../../constants/get_storage.dart' show storage;
import '../../../constants/my_colors.dart';
import '../../../controllers/service_provider/provider_offers_provider.dart';
import '../../widgets/border_radius_card.dart';
import '../../widgets/button_styles.dart';
import '../../widgets/home/appbar_home.dart';
import '../../widgets/home/background_appbar_home.dart';
import '../../widgets/provider/home_build_legend_Item.dart';
import '../../widgets/provider/home_chart.dart';
import '../../widgets/provider/home_stats_card.dart';
import '../../widgets/sized_box.dart';
import '../../widgets/title_section.dart';
import '../auth/freedaysscreen.dart';
import '../home_client/projectForUserDetails.dart';
import 'request_details_provider_screen.dart';
import 'request_offer_provider_screen.dart';

class HomeProviderScreen extends StatefulWidget {
  HomeProviderScreen({super.key});

  @override
  State<HomeProviderScreen> createState() => _HomeProviderScreenState();
}

class _HomeProviderScreenState extends State<HomeProviderScreen> {
  bool _isFetched = false;
  ResponseHandler<ProviderHomePage>? _providerHome;
  ResponseHandler<CustomerHome>? _customerHome;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProviderHomeData();
  }

  @override
  void didChangeDependencies() {
    if (!_isFetched) {
      _fetchProviderHomeData();
    }
    super.didChangeDependencies();
  }

  Future<void> _fetchProviderHomeData() async {
    final fetchedData =
        await Provider.of<ProviderHomePageProvider>(context, listen: false)
            .fetchProviderHomePage();
    if (!mounted) return;

    setState(() {
      _providerHome = fetchedData;
      _isFetched = true;
    });
    await storage.write(
        'verified_provider', _providerHome!.response!.providerAccount!.id_verifed);
    await storage.write(
        'offer_count', fetchedData.response!.providerAccount!.offerCount);
    await storage.write(
        'provider_id', fetchedData.response!.providerAccount!.id);
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        // BackgroundAppbarHome(
        //   imageAssetPath: 'assets/Icons/home_background.jpeg',
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        // ),

        Column(
          children: [
            SizedBoxedH16,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppbarHome(),
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              height: 2, // Thickness of the divider
              decoration: BoxDecoration(
                color: Colors.grey[300], // Divider color
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 2), // Shadow goes downward
                    blurRadius: 4,
                  ),
                ],
                borderRadius:
                    BorderRadius.circular(4), // Optional rounded edges
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Expanded(
                child: ClipRRect(
              borderRadius: topBorderRadiusCard,
              child: RefreshIndicator(
                onRefresh: _fetchProviderHomeData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: !_isFetched
                      ? loaderWidget(context, type: 'home')
                      : _providerHome!.status == ResponseStatus.error
                          ? _buildErrorWidget()
                          : Card(
                              color: Colors.white,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: topBorderRadiusCard),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    SizedBoxedH16,
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 16),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       Expanded(
                                    //         child: BuildStatsCard(
                                    //           'العروض المتاحة لي',
                                    //           _providerHome!
                                    //               .response!.stats!.offerCount!
                                    //               .toString(),
                                    //           Colors.redAccent,
                                    //         ),
                                    //       ),
                                    //       const SizedBox(width: 16),
                                    //       Expanded(
                                    //         child: BuildStatsCard(
                                    //           'العروض المقدمة',
                                    //           _providerHome!
                                    //               .response!.stats!.offersCount!
                                    //               .toString(),
                                    //           Colors.black,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // const SizedBox(height: 24),

                                    // Filter sliders by type
                                    if (_providerHome!.response!.sliders !=
                                        null) ...[
                                      if (_providerHome!.response!.sliders!.any(
                                          (slider) =>
                                              slider.type == "provider"))
                                        CarouselSliderHome(
                                          slides: _providerHome!
                                              .response!.sliders!
                                              .where((slider) =>
                                                  slider.type == "provider")
                                              .toList(),
                                          catergoryTitle: _providerHome!
                                              .response!.categories,
                                        ),
                                    ],

                                    // الأشهر
                                    TitleSections(
                                      title: 'احصائيات',
                                      isViewAll: false,
                                      onTapView: () {},
                                    ),
                                    const SizedBox(height: 16),
                                    // المخطط البياني
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        child: BuildChart(
                                            _providerHome!.response!.chart),
                                      ),
                                    ),

                                    // التوضيحات
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          BuildLegendItem(
                                            'جار التنفيذ',
                                            Colors.grey,
                                            _providerHome!.response!.stats!
                                                .workingServices!
                                                .toString(),
                                          ),
                                          BuildLegendItem(
                                            'العروض المقبولة',
                                            Colors.redAccent,
                                            _providerHome!.response!.stats!
                                                .acceptedOffers!
                                                .toString(),
                                          ),
                                          BuildLegendItem(
                                            'الطلبات المنتهية',
                                            Colors.black,
                                            _providerHome!
                                                .response!.stats!.doneServices!
                                                .toString(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBoxedH16,
                                    Divider(
                                        color: Colors.grey.withOpacity(0.1),
                                        thickness: 10),
                                    SizedBoxedH16,

                                    TitleSections(
                                      title: 'العروض الاخيرة',
                                      isViewAll: false,
                                      onTapView: () {},
                                    ),
                                    SizedBoxedH16,
                                    ListView.builder(
                                      itemCount: _providerHome!
                                          .response!.latestServices!.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (ctx, index) {

                                        return LatestServiceCard(
                                          serviceDetails: _providerHome!
                                              .response!.latestServices![index],
                                          verified: _providerHome!.response!
                                              .providerAccount!.id_verifed,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                ),
              ),
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Column(
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
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Text(
                'Try Again'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                _isFetched = false;
                _fetchProviderHomeData();
              });
            },
          ),
        ),
      ],
    );
  }

  // Helper method to build stats section
  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: BuildStatsCard(
              'اجمالي العروض',
              _providerHome!.response!.stats!.offerCount!.toString(),
              Colors.redAccent,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: BuildStatsCard(
              'الطلبات المتاحة',
              _providerHome!.response!.stats!.offersCount!.toString(),
              Colors.black,
            ),
          ),
        ],
      ),
    );
  }

// ... rest of your existing code ...
}

class LatestServiceCard extends StatefulWidget {
  Service serviceDetails;
  int? verified;

  LatestServiceCard(
      {super.key, required this.serviceDetails, required this.verified});

  @override
  State<LatestServiceCard> createState() => _LatestServiceCardState();
}

class _LatestServiceCardState extends State<LatestServiceCard> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Padding(
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
                    imageUrl: widget.serviceDetails.image!,
                    height: 120,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.serviceDetails.title!.tr(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: MyColors.Darkest,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Card(
                            color: MyColors.cardPriceBackgroundColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 12),
                              child: Text(
                                '${widget.serviceDetails.price!} دينار',
                                style: const TextStyle(
                                    fontSize: 12, color: MyColors.MainPrimary),
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
                          Text(
                            'بداية من ' + widget.serviceDetails.date!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: MyColors.textColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBoxedH8,
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                style: flatButtonPrimaryStyle,
                                onPressed: widget.verified == 1
                                    ? () async {
                                        final result =
                                            await showModalBottomSheet(
                                          backgroundColor: Colors.white,
                                          context: context,
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(16)),
                                          ),
                                          builder: (context) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom,
                                              ),
                                              child: _buildBottomSheetContent(
                                                  context,
                                                  widget.serviceDetails.id!),
                                            );
                                          },
                                        );

                                        if (result == 'success') {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) => OfferSuccessPage()),
                                          );
                                        } else if (result == "apply") {
                                          // Navigator.of(context).push(
                                          //   MaterialPageRoute(builder: (_) => OfferSuccessPage()),
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("لقد قمت بالتقديم مسبفا")));
                                          // );
                                        } else {
                                          result != null
                                              ? ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("$result")))
                                              : null;
                                        }
                                        // final int offerCount =
                                        //     storage.read('offer_count') ?? 0;
                                        // final int providerId =
                                        //     storage.read('provider_id') ?? 0;
                                        // if (offerCount == 1) {
                                        //   // Show confirmation dialog
                                        //   final result =
                                        //       await showDialog<String>(
                                        //     context: context,
                                        //     builder: (BuildContext context) {
                                        //       return Directionality(
                                        //         textDirection:
                                        //             TextDirection.rtl,
                                        //         child: AlertDialog(
                                        //           title: Text(
                                        //               ' تنبيه  مشروع - ${widget.serviceDetails.title}'),
                                        //           content: Text(
                                        //               'تملك حالياً عرض واحد فقط. هل ترغب بالانسحاب من باقي التقديمات أم شراء عروض إضافية؟'),
                                        //           actions: [
                                        //             TextButton(
                                        //               onPressed: () {
                                        //                 Navigator.of(context)
                                        //                     .pop('withdraw');
                                        //               },
                                        //               child: Text(
                                        //                   'انسحاب من باقي المشاريع'),
                                        //             ),
                                        //             TextButton(
                                        //               onPressed: () {
                                        //                 Navigator.of(context)
                                        //                     .pop('purchase');
                                        //               },
                                        //               child: Text(
                                        //                   'شراء عروض إضافية'),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       );
                                        //     },
                                        //   );
                                        //
                                        //   if (result == 'withdraw') {
                                        //     // Delete pending offers
                                        //     final response = await Provider.of<
                                        //                 ProviderServicesProvider>(
                                        //             context,
                                        //             listen: false)
                                        //         .deletePendingOffers(
                                        //             providerId);
                                        //
                                        //     if (response.status ==
                                        //         ResponseStatus.success) {
                                        //       Navigator.of(context).push(
                                        //         MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               RequestOfferProviderScreen(
                                        //             serviceDetails:
                                        //                 widget.serviceDetails,
                                        //           ),
                                        //         ),
                                        //       );
                                        //     } else {
                                        //       ScaffoldMessenger.of(context)
                                        //           .showSnackBar(
                                        //         SnackBar(
                                        //           content: Text(response
                                        //                   .errorMessage ??
                                        //               'حدث خطأ أثناء حذف العروض المعلقة'),
                                        //         ),
                                        //       );
                                        //     }
                                        //   } else if (result == 'purchase') {
                                        //     Navigator.of(context).push(
                                        //       MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             PackagesScreen(),
                                        //       ),
                                        //     );
                                        //   }
                                        // } else {
                                        //   Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           RequestOfferProviderScreen(
                                        //         serviceDetails:
                                        //             widget.serviceDetails,
                                        //       ),
                                        //     ),
                                        //   );
                                        // }
                                      }
                                    : null,
                                child: Text(
                                  'تقديم'.tr(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                style: flatButtonLightStyle,
                                onPressed: () async {


                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProjectForUserDetails(
                                            service: widget.serviceDetails,
                                          )));
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         PlansScreen(
                                  //
                                  //         ),
                                  //   ),
                                  // );
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         RequestDetailsProviderScreen(
                                  //       loadedService: widget.serviceDetails,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Text(
                                  'عرض تفاصيل'.tr(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: MyColors.Darkest),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheetContent(BuildContext context, int id) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'اضافة تعليق',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xff181829),
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close, size: 32, color: Color(0xff181829)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffF7F8FA),
              borderRadius: BorderRadius.circular(32),
            ),
            child: TextField(
              controller: _commentController,
              maxLines: 4,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'اكتب تعليق حول الخدمة (إختياري)....',
                hintStyle: TextStyle(
                  color: Color(0xffC6C6C8),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffDD5B4B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onPressed: () async {
                ResponseHandler response =
                    await Provider.of<ProviderOffersProvider>(context,
                            listen: false)
                        .createOfferForServiceRequest(
                  serviceId: id,
                  content: _commentController.text,
                );

                if (response.status == ResponseStatus.success) {
                  Navigator.of(context).pop("success");
                } else if (response.errorMessage != null) {
                  Navigator.of(context).pop(response.errorMessage);
                } else {
                  Navigator.of(context).pop("apply");
                }
              },
              child: Text(
                'التقديم على المشروع',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _shimmerBox({required double width, required double height}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

Widget _shimmerIcon() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    ),
  );
}
