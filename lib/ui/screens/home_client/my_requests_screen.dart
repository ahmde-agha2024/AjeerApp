import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/customer/customer_orders_provider.dart';
import 'package:ajeer/controllers/general/statusprovider.dart';
import 'package:ajeer/models/customer/service_model.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart' show PusherChannelsFlutter;

import '../../../constants/my_colors.dart';
import '../../widgets/button_styles.dart';
import '../../widgets/my_requests/appbar_my_requests.dart';
import '../../widgets/my_requests/request_details_screen.dart';
import '../../widgets/sized_box.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ResponseHandler<ServiceResponse>? customerServicesResponse;
  bool _isFetched = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabSelection);
    connectPusher();
  }

  @override
  void didChangeDependencies() {
    if (!_isFetched) {
      _fetchData();
    }
    super.didChangeDependencies();
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
          onEvent: (event) async{
            await  _fetchData();
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
      _isFetched = true;
    });
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      _fetchData();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildCategoryItem(String categoryName, int index) {
    bool isSelected = _tabController.index == index;
    return ChoiceChip(
      label: Text(categoryName),
      selected: isSelected,
      checkmarkColor: Colors.white,
      onSelected: (bool selected) {
        _tabController.animateTo(index);
      },
      selectedColor: MyColors.MainBulma,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const SizedBox(height: 66),
          AppbarHomeCustom(
            title: 'My requests',
          ),
          SizedBoxedH24,
          if (!_isFetched) loaderWidget(context, type: "tab_view"),
          if (_isFetched &&
              customerServicesResponse!.status == ResponseStatus.error)
            Column(
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
                          _fetchData();
                        });
                      }),
                )
              ],
            ),
          if (_isFetched &&
              customerServicesResponse!.status == ResponseStatus.success)
            Container(
              color: MyColors.LightBackgroundGrey.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                  tabAlignment: TabAlignment.start,
                  tabs: [
                    _buildCategoryItem('جديد', 0),
                    _buildCategoryItem('المقبولة', 1),
                    _buildCategoryItem('في الطريق', 2),
                    _buildCategoryItem('جاري التنفيذ', 3),
                    _buildCategoryItem('مكتمل', 4),
                  ],
                ),
              ),
            ),
          if (_isFetched &&
              customerServicesResponse!.status == ResponseStatus.success)
            Expanded(
              child: NotificationListener<OverscrollNotification>(
                onNotification: (OverscrollNotification notification) {
                  if (notification.overscroll < 0) {
                    _fetchData();
                  }
                  return true;
                },
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    RefreshIndicator(
                      onRefresh: _fetchData,
                      child: _buildListView(customerServicesResponse!
                          .response!.currentServices
                          .where((element) => element.service_status == 'NEW')
                          .toList()),
                    ),
                    RefreshIndicator(
                      onRefresh: _fetchData,
                      child: _buildListView(customerServicesResponse!
                          .response!.currentServices
                          .where((element) => element.service_status == 'NEW_OFFER')
                          .toList()),
                    ),
                    RefreshIndicator(
                      onRefresh: _fetchData,
                      child: _buildListView(customerServicesResponse!
                          .response!.currentServices
                          .where((element) => element.service_status == 'onWay')
                          .toList()),
                    ),
                    RefreshIndicator(
                      onRefresh: _fetchData,
                      child: _buildListView(customerServicesResponse!
                          .response!.currentServices.where(
                              (element) => element.service_status == 'Work_Now')
                          .toList()),
                    ),
                    RefreshIndicator(
                      onRefresh: _fetchData,
                      child: _buildListView(customerServicesResponse!
                          .response!.currentServices
                          .where((element) => element.service_status == 'done_Work')
                          .toList()),
                    ),
                    // RefreshIndicator(
                    //   onRefresh: _fetchData,
                    //   child: _buildListView(customerServicesResponse!
                    //       .response!.currentServices
                    //       .where((element) => element.status == 'CANCELED')
                    //       .toList()),
                    // ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListView(List<Service> services) {
    if (services.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Icons/requestappIcon.png',
                height: 180, width: 180),
            const SizedBox(height: 16),
            Text(
              'Empty Orders , Orders Will Be Here'.tr(),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: MyColors.Darkest),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: services.length,
      shrinkWrap: true,
      itemBuilder: (ctx, index) {
        return ServiceRequestCard(
          requestedService: services[index],
          index: index,
          onRefresh: _fetchData,
        );
      },
    );
  }
}

class ServiceRequestCard extends StatefulWidget {
  Service requestedService;
  final VoidCallback onRefresh;
int index;
  ServiceRequestCard(
      {super.key, required this.requestedService, required this.onRefresh,required this.index});

  @override
  State<ServiceRequestCard> createState() => _ServiceRequestCardState();
}

class _ServiceRequestCardState extends State<ServiceRequestCard> {
  bool isCancelling = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                RequestDetailsScreen(requestedService: widget.requestedService),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(
              color: MyColors.lightGreyBackground,
              width: 2,
            )),
        elevation: 0,
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              leading: CachedNetworkImage(
                imageUrl: widget.requestedService.image!,
                imageBuilder: (context, imageProvider) => Container(
                  width: 64.0,
                  height: 64.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                    border: Border.all(
                      width: 3,
                      color: Colors.white,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(color: MyColors.MainBulma),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: MyColors.MainBulma),
              ),
              title: Text(widget.requestedService.title!),
              subtitle:
                  Text('طلب رقم : #${widget.requestedService.id.toString()}'),
              trailing: Card(
                color: MyColors.CardBackgroundNew,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: widget.requestedService.service_status =="NEW"?Text(
                    "جديد",
                    style: const TextStyle(
                      color: MyColors.MainBulma,
                    ),
                  ):widget.requestedService.service_status =="NEW_OFFER"?Text(
                    "تم قبول الطلب",
                    style: const TextStyle(
                      color: MyColors.MainBulma,
                    ),
                  ):widget.requestedService.service_status =="onWay"?Text(
                    "الفني في الطريق",
                    style: const TextStyle(
                      color: MyColors.MainBulma,
                    ),
                  ):widget.requestedService.service_status =="Work_Now"?Text(
                    "يتم التنفيذ الأن",
                    style: const TextStyle(
                      color: MyColors.MainBulma,
                    ),
                  ):widget.requestedService.service_status =="done_Work"?Text(
                    "إكتمل العمل",
                    style: const TextStyle(
                      color: MyColors.MainBulma,
                    ),
                  ):SizedBox(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Opacity(opacity: 0.5, child: Divider()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                leading: SvgPicture.asset('assets/svg/calender.svg'),
                title: Text(
                    "تاريخ الطلب ${widget.requestedService.date ?? 'غير محدد'}"),
                subtitle: Text(
                    "توقيت الطلب ${widget.requestedService.time ?? 'غير محدد'}"),
              ),
            ),
            SizedBoxedH8,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: TextButton(
                        style: flatButtonPrimaryStyle,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RequestDetailsScreen(
                                requestedService: widget.requestedService,
                                index: widget.index,


                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'تفاصيل الطلب'.tr(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SvgPicture.asset('assets/svg/Cube.svg'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const SizedBox(width: 16),
                  if (widget.requestedService.status == 'DONE' &&
                      !widget.requestedService.isRated!)
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: TextButton(
                          style: flatButtonLightStyle,
                          onPressed: () {
                            _showRateBottomSheet(
                                context, widget.requestedService.id!);
                          },
                          child: Text(
                            'تقييم'.tr(),
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: MyColors.MainBulma),
                          ),
                        ),
                      ),
                    ),
                  if (widget.requestedService.status != 'DONE')
                    Expanded(
                      child: isCancelling
                          ? const Center(child: CircularProgressIndicator())
                          : widget.requestedService.status !=
                                      'OFFER_ACCEPTED' &&
                                  widget.requestedService.status != 'NEW'
                              ? const SizedBox(
                                  height: 0,
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: TextButton(
                                    style: flatButtonLightStyle,
                                    onPressed: widget.requestedService.status !=
                                                'OFFER_ACCEPTED' &&
                                            widget.requestedService.status !=
                                                'NEW'
                                        ? null
                                        : () async {
                                            setState(() {
                                              isCancelling = true;
                                            });
                                            ResponseHandler handledResponse =
                                                ResponseHandler(
                                                    status:
                                                        ResponseStatus.error);
                                            if (widget
                                                    .requestedService.status ==
                                                'OFFER_ACCEPTED') {
                                              handledResponse = await Provider
                                                      .of<CustomerOrdersProvider>(
                                                          context,
                                                          listen: false)
                                                  .finishServiceRequest(widget
                                                      .requestedService.id!);
                                            } else {
                                              handledResponse = await Provider
                                                      .of<CustomerOrdersProvider>(
                                                          context,
                                                          listen: false)
                                                  .cancelAServiceRequest(
                                                      widget
                                                          .requestedService.id!,
                                                      'REASONNNNNNNNNNNNNNNN');
                                            }
                                            setState(() {
                                              isCancelling = false;
                                            });
                                            if (handledResponse.status ==
                                                ResponseStatus.success) {
                                              if (widget.requestedService
                                                      .status ==
                                                  'OFFER_ACCEPTED') {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Text(
                                                      "تم إنهاء الخدمة بنجاح"
                                                          .tr()),
                                                ));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Text(
                                                      "تم إلغاء الخدمة بنجاح"
                                                          .tr()),
                                                ));
                                              }
                                              widget.onRefresh();
                                            } else if (handledResponse
                                                    .errorMessage !=
                                                null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                content: Text(handledResponse
                                                    .errorMessage!
                                                    .tr()),
                                              ));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                content:
                                                    Text("Error Occurred".tr()),
                                              ));
                                            }
                                          },
                                    child: Text(
                                      widget.requestedService.status ==
                                              'OFFER_ACCEPTED'
                                          ? 'إنهاء المشروع'.tr()
                                          : 'إلغاء المشروع'.tr(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: MyColors.Darkest),
                                    ),
                                  ),
                                ),
                    ),
                ],
              ),
            ),
            SizedBoxedH8,
          ],
        ),
      ),
    );
  }

  void _showRateBottomSheet(BuildContext context, int serviceId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final provider =
            Provider.of<CustomerOrdersProvider>(context, listen: false);
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'كيف كانت تجربتك مع الطلب؟'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildRatingSection(
                title: 'تقييم الخدمة',
                onRatingUpdate: (rating) {
                  provider.setOrderRating(rating);
                },
              ),
              const SizedBox(height: 16),
              _buildNotesSection(provider),
              const SizedBox(height: 32),
              Consumer<CustomerOrdersProvider>(
                builder: (context, provider, _) {
                  return provider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 64,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                MyColors.MainBulma,
                              ),
                            ),
                            onPressed: () async {
                              await provider.submitRating(
                                serviceId: serviceId,
                                serviceRating: provider.orderRating,
                                notes: provider.notesController.text,
                              );
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'تأكيد',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRatingSection({
    required String title,
    required Function(double rating) onRatingUpdate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RatingBar.builder(
          initialRating: 5,
          minRating: 1,
          itemCount: 5,
          itemBuilder: (context, _) =>
              const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: onRatingUpdate,
        ),
      ],
    );
  }

  Widget _buildNotesSection(CustomerOrdersProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أضف ملاحظاتك (اختياري)'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: provider.notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'اكتب ملاحظاتك هنا...',
          ),
        ),
      ],
    );
  }
}
