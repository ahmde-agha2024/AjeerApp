import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/models/customer/service_model.dart';
import 'package:ajeer/models/provider/provider_offers_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/my_colors.dart';
import '../../../controllers/general/statusprovider.dart';
import '../../widgets/appbar_title.dart';
import '../../widgets/button_styles.dart';
import '../../widgets/sized_box.dart';
import '../../widgets/title_section.dart';

class RequestDetailsProviderScreen extends StatefulWidget {
  Service loadedService;

  RequestDetailsProviderScreen({super.key, required this.loadedService});

  @override
  State<RequestDetailsProviderScreen> createState() =>
      _RequestDetailsProviderScreenState();
}

class _RequestDetailsProviderScreenState
    extends State<RequestDetailsProviderScreen> {
  late ResponseHandler<ProviderOffers> providerOffers =
      ResponseHandler(status: ResponseStatus.error);

  @override
  Widget build(BuildContext context) {
    print(widget.loadedService.image!);
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
                            // Row(
                            //   children: [
                            //     SvgPicture.asset('assets/svg/request_calender.svg'),
                            //     const SizedBox(width: 6),
                            //     const Text(
                            //       'حتي 10/8/2024',
                            //       style: TextStyle(
                            //         fontSize: 12,
                            //         color: MyColors.textColor,
                            //       ),
                            //     ),
                            //   ],
                            // ),
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
          Divider(color: Colors.grey.withOpacity(0.1), thickness: 10),
          SizedBoxedH16,
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
            // subtitle: Text(
            //   widget.loadedService.customer!.phone!,
            //   style: const TextStyle(
            //     fontSize: 14,
            //     color: MyColors.textColor,
            //   ),
            // ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // SvgPicture.asset('assets/svg/location_provider.svg'),
                // const SizedBox(width: 12),
                // SvgPicture.asset('assets/svg/message_provider.svg'),
                // const SizedBox(width: 12),

                // InkWell(
                //     onTap: () {
                //       launchUrl(Uri.parse('tel:${widget.loadedService.customer?.phone}'));
                //     },
                //     child: SvgPicture.asset('assets/svg/call_provider.svg'))
              ],
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
                      },
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
          TitleSections(
              title: 'حالة الطلب', isViewAll: false, onTapView: () {}),
          SizedBoxedH16,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Visibility(
              child: TextButton(
                style: flatButtonPrimaryStyle,
                onPressed: () async {
                  print(widget.loadedService.service_status);
                  if (widget.loadedService.service_status == 'NEW_OFFER') {
                    await StatusProviderController.changeStatus(
                        widget.loadedService.id.toString(), "onWay");
                  } else if (widget.loadedService.service_status == 'onWay') {
                    await StatusProviderController.changeStatus(
                        widget.loadedService.id.toString(), "Work_Now");
                  } else if (widget.loadedService.service_status ==
                      'Work_Now') {
                    await StatusProviderController.changeStatus(
                        widget.loadedService.id.toString(), "done_Work");
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.loadedService.service_status == 'NEW_OFFER'
                        ? Expanded(
                            child: const Text(
                              textAlign: TextAlign.center,
                              "تم قبول العرض , سيتم التنفيذ في الوقت المحدد",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          )
                        : widget.loadedService.service_status == 'onWay'
                            ? const Text(
                                textAlign: TextAlign.center,
                                "الفني في الطريق",
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            : widget.loadedService.service_status == 'Work_Now'
                                ? const Text(
                                    textAlign: TextAlign.center,
                                    "يتم تنفيذ العمل الأن",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  )
                                : widget.loadedService.service_status ==
                                        'done_Work'
                                    ? Expanded(
                                        child: const Text(
                                          textAlign: TextAlign.center,
                                          "إكتمل العمل , تم الدفع",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      )
                                    : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          // Divider(color: Colors.grey.withOpacity(0.1), thickness: 10),
          // SizedBoxedH16,
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: SizedBox(
          //     width: double.infinity,
          //     height: 64,
          //     child: TextButton(
          //       style: flatButtonPrimaryStyle,
          //       onPressed: () async {
          //         Navigator.of(context).push(
          //           MaterialPageRoute(
          //             builder: (context) => RequestOfferProviderScreen(
          //               serviceDetails: widget.loadedService,
          //             ),
          //           ),
          //         );
          //       },
          //       child: Text(
          //         'تقديم'.tr(),
          //         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBoxedH16,
          SizedBoxedH16,
        ],
      ),
    );
  }
}
