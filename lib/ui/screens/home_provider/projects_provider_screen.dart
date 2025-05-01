import 'package:ajeer/constants/get_storage.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/service_provider/provider_services_provider.dart';
import 'package:ajeer/models/customer/service_model.dart';
import 'package:ajeer/ui/screens/home_provider/request_details_provider_screen.dart';
import 'package:ajeer/ui/screens/home_provider/request_offer_provider_screen.dart';
import 'package:ajeer/ui/widgets/button_styles.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../constants/my_colors.dart';
import '../../widgets/sized_box.dart';
import 'packages_screen.dart';

class ProjectsProviderScreen extends StatefulWidget {
  const ProjectsProviderScreen({super.key});

  @override
  State<ProjectsProviderScreen> createState() => _ProjectsProviderScreenState();
}

class _ProjectsProviderScreenState extends State<ProjectsProviderScreen> {
  bool _isFetched = false;
  ResponseHandler<List<Service>> handledResponse =
      ResponseHandler(status: ResponseStatus.error);

  @override
  void didChangeDependencies() {
    if (!_isFetched) {
      _fetchNewServices();
    }
    super.didChangeDependencies();
  }

  Future<void> _fetchNewServices() async {
    final fetchedData =
        await Provider.of<ProviderServicesProvider>(context, listen: false)
            .getAllNewServices();
    setState(() {
      handledResponse = fetchedData;
      _isFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(read);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المشاريع'.tr(),
          style: const TextStyle(
            color: MyColors.Darkest,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _fetchNewServices, // السحب لتحديث البيانات
        child: !_isFetched
            ? loaderWidget(context, type: "card")
            : handledResponse.status == ResponseStatus.error
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
                                'Try Again'.tr(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isFetched = false;
                                _fetchNewServices();
                              });
                            }),
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBoxedH16,
                      handledResponse.response!.length != 0
                          ? Expanded(
                              child: ListView.builder(
                                  itemCount: handledResponse.response!.length,
                                  itemBuilder: (ctx, index) {
                                    return ProviderServiceRequestCard(
                                      service: handledResponse.response![index],
                                    );
                                  }),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                      'assets/Icons/removedocumentIcon.png',
                                      height: 110,
                                      width: 110),
                                  const SizedBox(height: 16),
                                  Text(
                                    'لا يوجد مشاريع ,ستكون المشاريع هنا',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: MyColors.Darkest),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
      ),
    );
  }
}

class ProviderServiceRequestCard extends StatefulWidget {
  Service service;

  ProviderServiceRequestCard({required this.service});

  @override
  State<ProviderServiceRequestCard> createState() =>
      _ProviderServiceRequestCardState();
}

class _ProviderServiceRequestCardState
    extends State<ProviderServiceRequestCard> {
  final int verified = storage.read('verified_provider');
  final int offerCount = storage.read('offer_count') ?? 0;
  final int providerId = storage.read('provider_id') ?? 0;

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
                    imageUrl: widget.service.image!,
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
                              '${widget.service.title!}',
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
                                '${widget.service.price!} دينار',
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
                          Expanded(
                            child: Text(
                              'تاريخ الطلب ${widget.service.date!}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: MyColors.textColor,
                              ),
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
                                onPressed: verified == 1
                                    ? () async {

                                        if (offerCount == 1) {
                                          // Show confirmation dialog
                                          final result =
                                              await showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Directionality(
                                                textDirection: TextDirection.rtl,
                                                child: AlertDialog(
                                                  title: Text(
                                                      ' تنبيه  مشروع - ${widget.service.title}'),
                                                  content: Text(
                                                      'تملك حالياً عرض واحد فقط. هل ترغب بالانسحاب من باقي التقديمات أم شراء عروض إضافية؟'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop('withdraw');
                                                      },
                                                      child: Text(
                                                          'انسحاب من باقي المشاريع'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop('purchase');
                                                      },
                                                      child: Text(
                                                          'شراء عروض إضافية'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );

                                          if (result == 'withdraw') {

                                            // Delete pending offers
                                            final response = await Provider.of<ProviderServicesProvider>(context, listen: false)
                                                .deletePendingOffers(providerId);

                                            if (response.status == ResponseStatus.success) {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      RequestOfferProviderScreen(
                                                    serviceDetails:
                                                        widget.service,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(response.errorMessage ?? 'حدث خطأ أثناء حذف العروض المعلقة'),
                                                ),
                                              );
                                            }
                                          } else if (result == 'purchase') {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PackagesScreen(),
                                              ),
                                            );
                                          }
                                        }else{
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RequestOfferProviderScreen(
                                                    serviceDetails:
                                                    widget.service,
                                                  ),
                                            ),
                                          );
                                        }
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
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RequestDetailsProviderScreen(
                                        loadedService: widget.service,
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
