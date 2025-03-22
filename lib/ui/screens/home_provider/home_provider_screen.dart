import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/service_provider/provider_home_page_provider.dart';
import 'package:ajeer/models/customer/service_model.dart';
import 'package:ajeer/models/customer/service_provider_model.dart';
import 'package:ajeer/models/provider/home/provider_home_model.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/get_storage.dart' show storage;
import '../../../constants/my_colors.dart';
import '../../widgets/border_radius_card.dart';
import '../../widgets/button_styles.dart';
import '../../widgets/home/appbar_home.dart';
import '../../widgets/home/background_appbar_home.dart';
import '../../widgets/provider/home_build_legend_Item.dart';
import '../../widgets/provider/home_chart.dart';
import '../../widgets/provider/home_stats_card.dart';
import '../../widgets/sized_box.dart';
import '../../widgets/title_section.dart';
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
    await storage.write('verified_provider', fetchedData.response!.providerAccount!.id_verifed);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundAppbarHome(
          imageAssetPath: 'assets/Icons/home_background.jpeg',
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
        ),
        Column(
          children: [
            SizedBoxedH16,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppbarHome(),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Expanded(
                                      child: BuildStatsCard(
                                        'العروض المتاحة لي',
                                        _providerHome!.response!.stats!
                                            .offerCount!.toString(),
                                        Colors.redAccent,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: BuildStatsCard(
                                        'عروض بإنتظار الموافقة',
                                        _providerHome!.response!.stats!
                                            .offersCount!.toString(),
                                        Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

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
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.5,
                                  child: BuildChart(
                                      _providerHome!.response!.chart),
                                ),
                              ),

                              // التوضيحات
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    BuildLegendItem(
                                      'جار التنفيذ',
                                      Colors.grey,
                                      _providerHome!.response!.stats!
                                          .workingServices!.toString(),
                                    ),
                                    BuildLegendItem(
                                      'العروض المقبولة',
                                      Colors.redAccent,
                                      _providerHome!.response!.stats!
                                          .acceptedOffers!.toString(),
                                    ),
                                    BuildLegendItem(
                                      'الطلبات المنتهية',
                                      Colors.black,
                                      _providerHome!.response!.stats!
                                          .doneServices!.toString(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBoxedH16,
                              Divider(color: Colors.grey.withOpacity(0.1),
                                  thickness: 10),
                              SizedBoxedH16,

                              TitleSections(
                                title: 'العروض الاخيرة',
                                isViewAll: false,
                                onTapView: () {},
                              ),
                              SizedBoxedH16,
                              ListView.builder(
                                itemCount: _providerHome!.response!
                                    .latestServices!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (ctx, index) {
                                  return LatestServiceCard(
                                     serviceDetails: _providerHome!.response!
                                        .latestServices![index],
                                    verified:_providerHome!.response!.providerAccount!.id_verifed ,
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
          builder: (context) =>
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: MyColors.MainBulma,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 12),
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
      {super.key, required this.serviceDetails,required this.verified});

  @override
  State<LatestServiceCard> createState() => _LatestServiceCardState();
}

class _LatestServiceCardState extends State<LatestServiceCard> {

  @override
  Widget build(BuildContext context) {
print('widget.verified');
print(widget.verified);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.9,
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
                                onPressed:widget.verified==1? () async {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RequestOfferProviderScreen(
                                            serviceDetails: widget
                                                .serviceDetails,
                                          ),
                                    ),
                                  );
                                }:null,
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
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RequestDetailsProviderScreen(
                                            loadedService: widget
                                                .serviceDetails,
                                          ),
                                    ),
                                  );
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
