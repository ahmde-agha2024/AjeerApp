import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/models/customer/service_model.dart';
import 'package:ajeer/models/provider/provider_offers_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import '../../../constants/get_storage.dart';
import '../../../constants/my_colors.dart';
import '../../../controllers/general/statusprovider.dart';
import '../../../controllers/service_provider/provider_services_provider.dart';
import '../../widgets/appbar_title.dart';
import '../../widgets/button_styles.dart';
import '../../widgets/common/status_tracker_widget.dart';
import '../../widgets/sized_box.dart';
import '../../widgets/title_section.dart';

class RequestDetailsProviderScreen extends StatefulWidget {
  Service loadedService;
  final Function(Service)? onServiceUpdated;

  RequestDetailsProviderScreen({
    super.key,
    required this.loadedService,
    this.onServiceUpdated,
  });

  @override
  State<RequestDetailsProviderScreen> createState() =>
      _RequestDetailsProviderScreenState();
}

class _RequestDetailsProviderScreenState
    extends State<RequestDetailsProviderScreen> {
  late ResponseHandler<ProviderOffers> providerOffers =
      ResponseHandler(status: ResponseStatus.error);
  String currentStatus = '';
  bool isLoading = false;
  final int providerId = storage.read('provider_id') ?? 0;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.loadedService.service_status!;
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() {
      currentStatus = newStatus;
      widget.loadedService.service_status = newStatus;
    });

    // Notify parent about the update
    if (widget.onServiceUpdated != null) {
      widget.onServiceUpdated!(widget.loadedService);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(title: 'طلب رقم #${widget.loadedService.id}'),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Divider(
            color: Colors.grey.withOpacity(0.1),
            thickness: 10,
          ),
          SizedBoxedH16,
          TitleSections(
              title: 'تفاصيل الخدمة', isViewAll: false, onTapView: () {}),
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
                      padding:
                          const EdgeInsets.only(top: 16, bottom: 16, right: 8),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.loadedService.image!,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          height: 120,
                          width: 100,
                          fit: BoxFit.cover,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.loadedService.title!,
                                    style: const TextStyle(
                                      fontSize: 16,
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
                                      '${widget.loadedService.price} دينار',
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
                                SvgPicture.asset(
                                    'assets/svg/request_calender.svg'),
                                const SizedBox(width: 6),
                                Text(
                                  'تاريخ الطلب ${widget.loadedService.date}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: MyColors.textColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBoxedH8,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey.withOpacity(0.1),
            thickness: 10,
          ),
          SizedBoxedH16,
          if (widget.loadedService.provider?.id == providerId) ...[
            TitleSections(
                title: 'حالة الطلب', isViewAll: false, onTapView: () {}),
            StatusTrackerWidget(currentStatus: currentStatus),
            SizedBoxedH16,
            Visibility(
              visible: currentStatus != 'done_Work' && currentStatus != 'NEW',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: TextButton(
                  style: flatButtonPrimaryStyle,
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            if (currentStatus == 'NEW_OFFER') {
                              await StatusProviderController.changeStatus(
                                  widget.loadedService.id.toString(), "onWay");
                              await _updateStatus("onWay");
                            } else if (currentStatus == 'onWay') {
                              await StatusProviderController.changeStatus(
                                  widget.loadedService.id.toString(),
                                  "Work_Now");
                              await _updateStatus("Work_Now");
                            } else if (currentStatus == 'Work_Now') {
                              await StatusProviderController.changeStatus(
                                  widget.loadedService.id.toString(),
                                  "done_Work");
                              await _updateStatus("done_Work");
                            }
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (isLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      else
                        currentStatus == 'NEW_OFFER'
                            ? Expanded(
                                child: const Text(
                                  textAlign: TextAlign.center,
                                  "الفني في الطريق",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              )
                            : currentStatus == 'onWay'
                                ? const Text(
                                    textAlign: TextAlign.center,
                                    "يتم تنفيذ العمل الأن",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  )
                                : currentStatus == 'Work_Now'
                                    ? const Text(
                                        textAlign: TextAlign.center,
                                        "إكتمل العمل , تم الدفع",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      )
                                    : currentStatus == 'done_Work'
                                        ? SizedBox()
                                        : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
            // Visibility(
            //   visible: currentStatus == 'done_Work',
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 100),
            //     child: Container(
            //       padding:
            //           const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            //       decoration: BoxDecoration(
            //         color: MyColors.MainPrimary,
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       child: const Text(
            //         textAlign: TextAlign.center,
            //         "إكتمل العمل , تم الدفع",
            //         style: TextStyle(
            //           fontSize: 14,
            //           fontWeight: FontWeight.w500,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBoxedH16,
            Divider(color: Colors.grey.withOpacity(0.1), thickness: 10),
            SizedBoxedH16,
          ],
          TitleSections(
              title: 'بيانات العميل', isViewAll: false, onTapView: () {}),
          SizedBoxedH16,
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: CachedNetworkImageProvider(
                widget.loadedService.customer!.image!,
              ),
            ),
            title: Text(
              widget.loadedService.customer!.name!,
              style: const TextStyle(
                fontSize: 16,
                color: MyColors.Darkest,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [],
            ),
          ),
          SizedBoxedH16,
          Divider(color: Colors.grey.withOpacity(0.1), thickness: 10),
          SizedBoxedH16,
          TitleSections(
              title: 'وصف المشكلة', isViewAll: false, onTapView: () {}),
          SizedBoxedH16,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.loadedService.content!,
              style: const TextStyle(
                fontSize: 14,
                color: MyColors.textColor,
              ),
            ),
          ),
          SizedBoxedH16,
          Divider(color: Colors.grey.withOpacity(0.1), thickness: 10),
          SizedBoxedH16,
          TitleSections(
              title: 'صور المشكلة', isViewAll: false, onTapView: () {}),
          SizedBoxedH16,
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
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
                                    BoxDecoration(color: Colors.white),
                                customSize: Size.fromWidth(300),
                                imageProvider:
                                    NetworkImage(widget.loadedService.image!),
                              ),
                            ),
                          ),
                        );
                    }  ,
                      child: CachedNetworkImage(
                        imageUrl: widget.loadedService.image!,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBoxedH16,
        ],
      ),
    );
  }
}
