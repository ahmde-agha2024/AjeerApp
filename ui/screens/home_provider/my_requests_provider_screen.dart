import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/service_provider/provider_services_provider.dart';
import 'package:ajeer/models/customer/service_model.dart';
import 'package:ajeer/models/provider/provider_services_model.dart';
import 'package:ajeer/ui/screens/home_provider/request_details_provider_screen.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../constants/my_colors.dart';
import '../../../controllers/general/statusprovider.dart';
import '../../widgets/button_styles.dart';
import '../../widgets/my_requests/appbar_my_requests.dart';

class MyRequestsProviderScreen extends StatefulWidget {
  MyRequestsProviderScreen({super.key});

  @override
  State<MyRequestsProviderScreen> createState() =>
      _MyRequestsProviderScreenState();
}

class _MyRequestsProviderScreenState extends State<MyRequestsProviderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFetched = false;
  ResponseHandler<ProviderServices> providerServices =
      ResponseHandler(status: ResponseStatus.error);

  @override
  void didChangeDependencies() {
    if (!_isFetched) {
      _fetchProviderServices();
    }
    super.didChangeDependencies();
  }

  Future<void> _fetchProviderServices() async {
    final fetchedData =
        await Provider.of<ProviderServicesProvider>(context, listen: false)
            .getMyServices();
    setState(() {
      providerServices = fetchedData;
      _isFetched = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 66),
          AppbarHomeCustom(
            title: 'طلباتي',
          ),
          const SizedBox(height: 16),
          !_isFetched
              ? loaderWidget(context, type: "tab_view")
              : providerServices.status == ResponseStatus.error
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
                                  _fetchProviderServices();
                                });
                              }),
                        )
                      ],
                    )
                  : Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: MyColors.MainBulma,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(
                            text: 'الطلبات الجديدة',
                          ),
                          Tab(
                            text: 'الطلبات السابقة',
                          ),
                        ],
                      ),
                    ),
          !_isFetched ? const SizedBox(height: 0) : const SizedBox(height: 16),
          !_isFetched
              ? const SizedBox(height: 0)
              : Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      providerServices.response?.workingOn?.length != 0
                          ? RefreshIndicator(
                              onRefresh: _fetchProviderServices,
                              child: ListView.builder(
                                itemCount: providerServices
                                        .response?.workingOn?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  return ServiceWorkingOnCard(
                                    service: providerServices
                                        .response!.workingOn![index],
                                    onRefresh: _fetchProviderServices,
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                      'assets/Icons/requestappIcon.png',
                                      height: 180,
                                      width: 180),
                                  const SizedBox(height: 16),
                                  Text(
                                    'لا يوجد طلبات جديدة ,ستكون الطلبات هنا !',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: MyColors.Darkest),
                                  ),
                                ],
                              ),
                            ),
                      providerServices.response?.done?.length != 0
                          ? RefreshIndicator(
                              onRefresh: _fetchProviderServices,
                              child: ListView.builder(
                                itemCount:
                                    providerServices.response?.done?.length ??
                                        0,
                                itemBuilder: (context, index) {
                                  String statusStringShowingToUser = '';
                                  switch (providerServices
                                      .response!.done![index].status) {
                                    case 'OFFER_ACCEPTED':
                                      statusStringShowingToUser =
                                          'تم قبول الطلب';
                                      break;
                                    case 'OFFER_REJECTED':
                                      statusStringShowingToUser =
                                          'تم رفض الطلب';
                                      break;
                                    case 'OFFER_CANCELED':
                                      statusStringShowingToUser =
                                          'تم الغاء الطلب';
                                      break;
                                    case 'OFFER_DONE':
                                      statusStringShowingToUser =
                                          'تم تنفيذ الطلب';
                                      break;
                                    case 'OFFER_PENDING':
                                      statusStringShowingToUser =
                                          'الطلب قيد الانتظار';
                                      break;
                                    case 'OFFER_EXPIRED':
                                      statusStringShowingToUser =
                                          'انتهت صلاحية الطلب';
                                      break;
                                    case 'OFFER_CANCELED_BY_CUSTOMER':
                                      statusStringShowingToUser =
                                          'تم الغاء الطلب من قبل العميل';
                                      break;
                                    case 'OFFER_CANCELED_BY_PROVIDER':
                                      statusStringShowingToUser =
                                          'تم الغاء الطلب من قبل العامل';
                                      break;
                                    case 'OFFER_CANCELED_BY_ADMIN':
                                      statusStringShowingToUser =
                                          'تم الغاء الطلب من قبل الادارة';
                                      break;
                                    default:
                                      statusStringShowingToUser = 'غير معروف';
                                  }

                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
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
                                            imageUrl: providerServices
                                                .response!.done![index].image!,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: 64.0,
                                              height: 64.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover),
                                                border: Border.all(
                                                  width: 3,
                                                  color: Colors.white,
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(
                                                    color: MyColors.MainBulma),
                                            errorWidget: (context, url,
                                                    error) =>
                                                const Icon(Icons.error,
                                                    color: MyColors.MainBulma),
                                          ),
                                          title: Text(providerServices
                                              .response!.done![index].title!),
                                          subtitle: Text(
                                              'طلب رقم : #${providerServices.response!.done![index].id!}'),
                                          trailing: Card(
                                            color: MyColors.CardBackgroundNew,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                              child: Text(
                                                statusStringShowingToUser,
                                                style: const TextStyle(
                                                  color: MyColors.MainBulma,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                      'assets/Icons/requestappIcon.png',
                                      height: 180,
                                      width: 180),
                                  const SizedBox(height: 16),
                                  Text(
                                    'لا يوجد طلبات سابقة ,ستكون الطلبات هنا !',
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
        ],
      ),
    );
  }
}

class ServiceWorkingOnCard extends StatefulWidget {
  Service service;
  final VoidCallback onRefresh;

  ServiceWorkingOnCard(
      {super.key, required this.service, required this.onRefresh});

  @override
  State<ServiceWorkingOnCard> createState() => _ServiceWorkingOnCardState();
}

class _ServiceWorkingOnCardState extends State<ServiceWorkingOnCard> {
  bool _isCancelling = false;

  @override
  Widget build(BuildContext context) {
    print(widget.service.service_status);
    String statusStringShowingToUser = '';
    if (widget.service.service_status == 'NEW_OFFER') {
      statusStringShowingToUser = 'تم قبول الطلب';
    } else if (widget.service.status == 'OFFER_REJECTED') {
      statusStringShowingToUser = 'تم رفض الطلب';
    } else if (widget.service.status == 'OFFER_CANCELED') {
      statusStringShowingToUser = 'تم الغاء الطلب';
    } else if (widget.service.status == 'OFFER_DONE') {
      statusStringShowingToUser = 'تم تنفيذ الطلب';
    } else if (widget.service.status == 'OFFER_PENDING') {
      statusStringShowingToUser = 'الطلب قيد الانتظار';
    } else if (widget.service.status == 'OFFER_EXPIRED') {
      statusStringShowingToUser = 'انتهت صلاحية الطلب';
    } else if (widget.service.status == 'OFFER_CANCELED_BY_CUSTOMER') {
      statusStringShowingToUser = 'تم الغاء الطلب من قبل العميل';
    } else if (widget.service.status == 'OFFER_CANCELED_BY_PROVIDER') {
      statusStringShowingToUser = 'تم الغاء الطلب من ق��ل العامل';
    } else if (widget.service.status == 'OFFER_CANCELED_BY_ADMIN') {
      statusStringShowingToUser = 'تم الغاء الطلب من قبل الادارة';
    } else {
      //statusStringShowingToUser = 'غير معروف';
    }
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(
              color: MyColors.lightGreyBackground,
              width: 2,
            )),
        elevation: 0,
        color: Colors.white,
        child: Column(children: [
          ListTile(
            leading: CachedNetworkImage(
              imageUrl: widget.service.image!,
              imageBuilder: (context, imageProvider) => Container(
                width: 64.0,
                height: 64.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
            title: Text(widget.service.title!),
            subtitle: Text('طلب رقم : #${widget.service.id!}'),
            trailing: statusStringShowingToUser=="" ?SizedBox():Card(
              color: MyColors.CardBackgroundNew,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  statusStringShowingToUser,
                  style: const TextStyle(
                    color: MyColors.MainBulma,
                  ),
                ),
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
              title: Text(widget.service.date ?? 'غير محدد'),
              subtitle: Text('الساعة ${widget.service.time ?? '00:00'}'),

            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: TextButton(
                      style: flatButtonPrimaryStyle,
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RequestDetailsProviderScreen(
                              loadedService: widget.service,
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
                                  fontSize: 14,
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
                Expanded(
                  child: _isCancelling
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: TextButton(
                            style: flatButtonLightStyle,
                            onPressed: () async {
                              setState(() {
                                _isCancelling = true;
                              });
                              ResponseHandler response =
                                  await Provider.of<ProviderServicesProvider>(
                                          context,
                                          listen: false)
                                      .cancelAService(
                                          widget.service.id!, 'reaaaason');
                              if (response.status == ResponseStatus.success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('تم الغاء الطلب بنجاح')));
                                widget.onRefresh();
                              } else if (response.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(response.errorMessage!)));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('حدث خطأ ما')));
                              }
                              setState(() {
                                _isCancelling = false;
                              });
                            },
                            child: Text(
                              'الغاء الطلب'.tr(),
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.Darkest),
                            ),
                          ),
                        ),
                ),
              ]))
        ]));
  }
}
