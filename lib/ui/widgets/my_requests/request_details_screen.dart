import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/customer/customer_orders_provider.dart';
import 'package:ajeer/controllers/service_provider/provider_home_page_provider.dart'
    show ProviderHomePageProvider;
import 'package:ajeer/models/common/chat_model.dart';
import 'package:ajeer/models/common/service_details_model.dart';
import 'package:ajeer/models/customer/service_model.dart';
import 'package:ajeer/ui/screens/provider_details_screen.dart';
import 'package:ajeer/ui/screens/single_chat_screen.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:convert';
import '../../../constants/domain.dart';
import '../../../constants/get_storage.dart';
import '../../../constants/my_colors.dart';
import '../../../controllers/general/statusprovider.dart';
import '../appbar_title.dart';
import '../button_styles.dart';
import '../common/status_tracker_widget.dart';
import '../sized_box.dart';
import '../title_section.dart';

class RequestDetailsScreen extends StatefulWidget {
  Service requestedService;
  int? index;
  final Function(Service)? onServiceUpdated;

  RequestDetailsScreen({
    super.key,
    required this.requestedService,
    this.index,
    this.onServiceUpdated,
  });

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  bool _isFetched = false;
  bool _isCancelling = false;
  String? _updatedServiceStatus;
  ResponseHandler<ServiceDetails>? serviceDetailsResponse;
  ResponseHandler<ServiceResponse>? customerServicesResponse;

  @override
  void initState() {
    super.initState();
    connectPusher();
    // _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> connectPusher() async {
    pusher = PusherChannelsFlutter.getInstance();

    try {
      await pusher.init(
        apiKey: '0727f1f58b92a8e76b84', // مفتاحك هنا
        cluster: 'eu', // كلسترك هنا
        onEvent: (event) {
          print('📢 Event received: ${event.eventName}');
          print('📃 Event data: ${event.data}');
        },
      );
      await pusher.subscribe(
          channelName: 'service-status',
          onEvent: (event) {
            print("test");
            _fetchData();
          });

      await pusher.connect();
      print('✅ Pusher connected.');
    } catch (e) {
      print('❌ Error connecting to Pusher: $e');
    }
  }

  Future<void> _fetchData() async {
    final fetchedData =
        await Provider.of<CustomerOrdersProvider>(context, listen: false)
            .fetchCustomerServices();
    if (!mounted) return;
    setState(() {
      customerServicesResponse = fetchedData;
      // Find the matching service in current services array
      final currentService = customerServicesResponse!.response!.currentServices
          .firstWhere((service) => service.id == widget.requestedService.id);
      _updatedServiceStatus = currentService.service_status;
      _isFetched = true;
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isFetched) {
      Provider.of<CustomerOrdersProvider>(context, listen: false)
          .fetchSingleCustomerService(widget.requestedService.id!)
          .then((fetchedServiceDetailsResponse) {
        setState(() {
          _isFetched = true;
          serviceDetailsResponse = fetchedServiceDetailsResponse;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.requestedService.service_status);
    return Scaffold(
      appBar: AppbarTitle(title: 'طلب رقم #${widget.requestedService.id}'),
      backgroundColor: Colors.white,
      body: !_isFetched
          ? loaderWidget(context, type: 'request_details')
          : serviceDetailsResponse!.status == ResponseStatus.error
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
              : ListView(
                  children: [
                    Divider(
                      color: Colors.grey.withOpacity(0.1),
                      thickness: 10,
                    ),
                    SizedBoxedH16,
                    TitleSections(
                        title: 'تفاصيل الخدمة',
                        isViewAll: false,
                        onTapView: () {}),
                    SizedBoxedH16,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16, bottom: 16, right: 8),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: PhotoView(
                                              backgroundDecoration:
                                                  BoxDecoration(
                                                      color: Colors.white),
                                              customSize: Size.fromWidth(300),
                                              imageProvider: NetworkImage(
                                                serviceDetailsResponse!
                                                    .response!.image,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: serviceDetailsResponse!
                                          .response!.image,
                                      height: 120,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              serviceDetailsResponse!
                                                  .response!.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: MyColors.Darkest,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Card(
                                            color: MyColors
                                                .cardPriceBackgroundColor,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 12),
                                              child: Text(
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        MyColors.MainPrimary),
                                                '${serviceDetailsResponse!.response!.price} دينار',
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBoxedH8,
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/svg/request_calender.svg'),
                                          const SizedBox(width: 6),
                                          Text(
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: MyColors.textColor,
                                            ),
                                            'تاريخ الطلب ${widget.requestedService.date ?? 'غير محدد'}\nالساعة ${widget.requestedService.time ?? 'غير محدد'}',
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
                    TitleSections(
                        title: 'حالة الطلب',
                        isViewAll: false,
                        onTapView: () {}),
                    StatusTrackerWidget(
                        currentStatus: _updatedServiceStatus ??
                            widget.requestedService.service_status),
                    Divider(color: Colors.grey.withOpacity(0.1), thickness: 10),
                    SizedBoxedH16,
                    TitleSections(
                        title: 'وصف المشكلة',
                        isViewAll: false,
                        onTapView: () {}),
                    SizedBoxedH16,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        serviceDetailsResponse!.response!.content,
                        style: const TextStyle(
                          fontSize: 14,
                          color: MyColors.textColor,
                        ),
                      ),
                    ),
                    SizedBoxedH16,
                    Divider(color: Colors.grey.withOpacity(0.1), thickness: 10),
                    SizedBoxedH16,
                    if (serviceDetailsResponse!.response!.gallery != null)
                      Column(
                        children: [
                          TitleSections(
                              title: 'صور المشكلة',
                              isViewAll: false,
                              onTapView: () {}),
                          SizedBoxedH16,
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: serviceDetailsResponse!
                                      .response!.gallery?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: serviceDetailsResponse!
                                          .response!.gallery![index],
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBoxedH16,
                          Divider(
                              color: Colors.grey.withOpacity(0.1),
                              thickness: 10),
                          SizedBoxedH16,
                        ],
                      ),
                    serviceDetailsResponse!.response!.acceptedOffer == null
                        ? TitleSections(
                            title:
                                'العروض ${serviceDetailsResponse!.response!.offers?.length ?? 0}',
                            isViewAll: false,
                            onTapView: () {})
                        : TitleSections(
                            title: 'العرض المقبول',
                            isViewAll: false,
                            onTapView: () {}),
                    SizedBoxedH16,
                    SizedBox(
                      height: 160,
                      child: serviceDetailsResponse!.response!.acceptedOffer ==
                              null
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: serviceDetailsResponse!
                                      .response!.offers?.length ??
                                  0,
                              itemBuilder: (ctx, index) {
                                return ServiceOfferCard(
                                  offer: serviceDetailsResponse!
                                      .response!.offers![index],
                                  service: widget.requestedService,
                                  onRefresh: () {
                                    setState(() {
                                      _isFetched = false;
                                    });
                                    didChangeDependencies();
                                  },
                                );
                              },
                            )
                          : ServiceOfferCard(
                              offer: serviceDetailsResponse!
                                  .response!.acceptedOffer!,
                              service: widget.requestedService,
                              isAccepted: true,
                              onRefresh: () {
                                setState(() {
                                  _isFetched = false;
                                });
                                didChangeDependencies();
                              },
                            ),
                    ),
                    SizedBoxedH16,
                  ],
                ),
    );
  }
}

class ServiceOfferCard extends StatefulWidget {
  Offer offer;
  bool isAccepted;
  Service service;
  final VoidCallback onRefresh;

  ServiceOfferCard(
      {required this.offer,
      super.key,
      this.isAccepted = false,
      required this.service,
      required this.onRefresh});

  @override
  State<ServiceOfferCard> createState() => _ServiceOfferCardState();
}

class _ServiceOfferCardState extends State<ServiceOfferCard> {
  bool _isAccepting = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 140,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      imageUrl: widget.offer.provider?.image ?? '',
                      height: 140,
                      width: MediaQuery.of(context).size.width * 0.25,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Wrap(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'عامل رقم ${widget.offer.provider?.id ?? '0000'}'
                                  .tr(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: MyColors.Darkest,
                                fontWeight: FontWeight.bold,
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
                                  '${widget.offer.price!} دينار',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: MyColors.MainPrimary),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBoxedH8,
                        Row(
                          children: [
                            // Text(
                            //   widget.offer.provider?.category?.title ??
                            //       'عامل أجير',
                            //   style: const TextStyle(
                            //     fontSize: 12,
                            //     color: MyColors.textColor,
                            //   ),
                            // ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/svg/request_calender.svg'),
                                const SizedBox(width: 6),
                                Text(
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: MyColors.textColor,
                                  ),
                                  'تاريخ الطلب ${widget.offer.date ?? 'غير محدد'}\nالساعة ${widget.offer.time ?? 'غير محدد'}',
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBoxedH16,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _isAccepting
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : SizedBox(
                                      child: widget.isAccepted
                                          ? TextButton(
                                              style: flatButtonPrimaryStyle,
                                              onPressed: () async {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SingleChatScreen(
                                                              chatHead:
                                                                  ChatHead(
                                                                provider: widget
                                                                    .offer
                                                                    .provider,
                                                              ),
                                                              service: widget
                                                                  .service,
                                                            )));
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'محادثة'
                                                        .tr(), // TODO TRANSLATE
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : TextButton(
                                              style: flatButtonPrimaryStyle,
                                              onPressed: () async {
                                                await StatusProviderController
                                                    .changeStatus(
                                                        widget.service.id
                                                            .toString(),
                                                        "NEW_OFFER");
                                                setState(() {
                                                  _isAccepting = true;
                                                });
                                                ResponseHandler
                                                    handledResponse =
                                                    await Provider.of<
                                                                CustomerOrdersProvider>(
                                                            context,
                                                            listen: false)
                                                        .acceptServiceOffer(
                                                            widget.offer.id!);
                                                if (handledResponse.status ==
                                                    ResponseStatus.success) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'تم قبول العرض بنجاح'
                                                              .tr()),
                                                    ),
                                                  );

                                                  widget.onRefresh();
                                                } else if (handledResponse
                                                        .errorMessage !=
                                                    null) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          handledResponse
                                                              .errorMessage!),
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'حدث خطأ ما'.tr()),
                                                    ),
                                                  );
                                                }
                                                setState(() {
                                                  _isAccepting = false;
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'قبول'.tr(),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                child: TextButton(
                                  style: flatButtonLightStyle,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProviderDetailsScreen(
                                                providerId:
                                                    widget.offer.provider?.id ??
                                                        1),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'عرض'.tr(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
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
    );
  }
}
