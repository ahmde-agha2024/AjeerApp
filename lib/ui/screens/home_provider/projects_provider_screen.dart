import 'package:ajeer/ui/screens/home_client/projectForUserDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/get_storage.dart';
import '../../../models/customer/service_model.dart';

import '../../widgets/my_requests/appbar_my_requests.dart';
import '../../widgets/sized_box.dart';

class ProjectsForUserScreen extends StatefulWidget {
  const ProjectsForUserScreen({Key? key}) : super(key: key);

  @override
  State<ProjectsForUserScreen> createState() => _ProjectsForUserScreenState();
}

class _ProjectsForUserScreenState extends State<ProjectsForUserScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Service> _services = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  static const int _pageSize = 15;
  final TextEditingController _commentController = TextEditingController();
  //final int verified = storage.read('verified_provider');

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoading && _hasMore) {
        _loadMoreData();
      }
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });
    await fetchServices(1);
  }

  Future<void> _loadMoreData() async {
    if (!_isLoading && _hasMore) {
      setState(() {
        _isLoading = true;
      });
      await fetchServices(_currentPage + 1);
    }
  }

  Future<void> fetchServices(int page) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://dev.ajeer.cloud/get-services?page_number=$page&page_size=15'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        List<Service> newServices = servicesListFromJson(data);
        print(newServices.length);
        setState(() {
          if (page == 1) {
            _services = newServices;
          } else {
            _services.addAll(newServices);
          }
          _currentPage = page;
          _hasMore = newServices.length == _pageSize;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasMore = false;
    });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 33),
          AppbarHomeCustom(
            title: 'مشاريع أخرى',
          ),
          SizedBoxedH24,
          Container(
            height: 2, // thickness of the divider

            decoration: BoxDecoration(
              color: Colors.white, // or any background color
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 2), // shadow only at bottom
                  blurRadius: 4,
                ),
              ],
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       children: [
          //         _FilterChip(
          //           icon: Icons.settings,
          //           label: 'فلترة',
          //           onTap: () {},
          //         ),
          //         SizedBox(width: 8),
          //         _DropdownChip(label: 'السعر'),
          //         SizedBox(width: 8),
          //         _DropdownChip(label: 'المدينة'),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: _services.isEmpty && _isLoading
                ? _buildShimmerLoading()
                : RefreshIndicator(
              onRefresh: () async {
                _currentPage = 1;
                _hasMore = true;
                await _loadInitialData();
              },
              child: GridView.builder(
                controller: _scrollController,
                padding: EdgeInsets.only(top: 8, bottom: 8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: _services.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _services.length) {
                    return Center(
                        child: CircularProgressIndicator(strokeWidth: 1,));
                  }
                  return _ProjectCard(service: _services[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    // عدد الأعمدة في الشبكة
    const int shimmerItemCount = 12;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount: shimmerItemCount,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0.5,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Container(
                      height: 60,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Center(
                          child: Container(
                            width: 60,
                            height: 12,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 10,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            3,
                                (i) => Column(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: 40,
                                  height: 10,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
      ),
          ),
    );
      },
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Service? service;

  const _ProjectCard({this.service});

  int _calculateDaysAgo(String? dateString) {
    if (dateString == null) return 0;
    try {
      // صيغة التاريخ: Wed, 26 Feb. 2025
      final DateFormat formatter = DateFormat('EEE, dd MMM. yyyy', 'en');
      DateTime serviceDate = formatter.parse(dateString);
      DateTime now = DateTime.now();
      return now.difference(serviceDate).inDays;
    } catch (e) {
      return 0;
    }
  }

  String convertDateToArabic(String? dateString) {
    try {
      // تأكد من أن المتغير String ثم نظّف التنسيق
      String cleanDate = dateString.toString().replaceAll('.', '').trim();

      // تحويل إلى كائن DateTime
      DateTime date = DateFormat('EEE, dd MMM yyyy', 'en').parse(cleanDate);

      // تنسيق النتيجة بالعربية
      String dayName = DateFormat.EEEE('ar').format(date);
      String formattedDate = DateFormat('d/M/yyyy', 'en').format(date);

      return '$dayName $formattedDate';
    } catch (e) {
      return 'تاريخ غير صالح';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProjectForUserDetails(
                  service: service!,
                )));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0.5,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                  imageUrl: service?.image ?? '',
                  height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Center(
                      child: Text(
                        service?.title ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      textAlign: TextAlign.center,
                      service?.content ?? '',
                      style: TextStyle(fontSize: 10, color: Color(0xff9F9F9F)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12),
                    Divider(height: 16, color: Color(0xffE04836), thickness: 1),
                    SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Column(
                          children: [
                            Icon(Icons.location_on_outlined,
                                color: Colors.red, size: 16),
                            SizedBox(height: 5),
                            Text(
                                service?.userAddress?.region?.title ?? 'طرابلس',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500)),
                        ],
                      ),
                        Column(
                        children: [
                            Icon(Icons.access_time_outlined,
                                color: Colors.red, size: 16),
                            SizedBox(height: 5),
                            Text(
                                'منذ ${_calculateDaysAgo(
                                  service?.date,
                                ).toString()} يوم',
                                style: TextStyle(fontSize: 10)),
                        ],
                      ),
                        Column(
                        children: [
                            Icon(Icons.filter_9_plus_outlined,
                                color: Colors.red, size: 16),
                            SizedBox(height: 5),
                            Text(
                                service?.offers?.length.toString() ?? '7 طلبات',
                                style: TextStyle(fontSize: 10)),
                          ],
                                                    ),
                                                  ],
                                                ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:ajeer/constants/get_storage.dart';
// import 'package:ajeer/constants/utils.dart';
// import 'package:ajeer/controllers/service_provider/provider_services_provider.dart';
// import 'package:ajeer/models/customer/service_model.dart';
// import 'package:ajeer/ui/screens/home_provider/request_details_provider_screen.dart';
// import 'package:ajeer/ui/screens/home_provider/request_offer_provider_screen.dart';
// import 'package:ajeer/ui/widgets/button_styles.dart';
// import 'package:ajeer/ui/widgets/common/error_widget.dart';
// import 'package:ajeer/ui/widgets/common/loader_widget.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:http/http.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
//
// import '../../../constants/my_colors.dart';
// import '../../widgets/sized_box.dart';
// import 'packages_screen.dart';
//
// class ProjectsProviderScreen extends StatefulWidget {
//   const ProjectsProviderScreen({super.key});
//
//   @override
//   State<ProjectsProviderScreen> createState() => _ProjectsProviderScreenState();
// }
//
// class _ProjectsProviderScreenState extends State<ProjectsProviderScreen> {
//   bool _isFetched = false;
//   ResponseHandler<List<Service>> handledResponse =
//       ResponseHandler(status: ResponseStatus.error);
//
//   @override
//   void didChangeDependencies() {
//     if (!_isFetched) {
//       _fetchNewServices();
//     }
//     super.didChangeDependencies();
//   }
//
//   Future<void> _fetchNewServices() async {
//     final fetchedData =
//         await Provider.of<ProviderServicesProvider>(context, listen: false)
//             .getAllNewServices();
//     setState(() {
//       handledResponse = fetchedData;
//       _isFetched = true;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print(read);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'المشاريع'.tr(),
//           style: const TextStyle(
//             color: MyColors.Darkest,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//       ),
//       backgroundColor: Colors.white,
//       body: RefreshIndicator(
//         onRefresh: _fetchNewServices, // السحب لتحديث البيانات
//         child: !_isFetched
//             ? loaderWidget(context, type: "card")
//             : handledResponse.status == ResponseStatus.error
//                 ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       errorWidget(context),
//                       Builder(
//                         builder: (context) => MaterialButton(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             color: MyColors.MainBulma,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 16, horizontal: 12),
//                               child: Text(
//                                 'Try Again'.tr(),
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _isFetched = false;
//                                 _fetchNewServices();
//                               });
//                             }),
//                       )
//                     ],
//                   )
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBoxedH16,
//                       handledResponse.response!.length != 0
//                           ? Expanded(
//                               child: ListView.builder(
//                                   itemCount: handledResponse.response!.length,
//                                   itemBuilder: (ctx, index) {
//                                     return ProviderServiceRequestCard(
//                                       service: handledResponse.response![index],
//                                     );
//                                   }),
//                             )
//                           : Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Image.asset(
//                                       'assets/Icons/removedocumentIcon.png',
//                                       height: 110,
//                                       width: 110),
//                                   const SizedBox(height: 16),
//                                   Text(
//                                     'لا يوجد مشاريع ,ستكون المشاريع هنا',
//                                     style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                         color: MyColors.Darkest),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                     ],
//                   ),
//       ),
//     );
//   }
// }
//
// class ProviderServiceRequestCard extends StatefulWidget {
//   Service service;
//
//   ProviderServiceRequestCard({required this.service});
//
//   @override
//   State<ProviderServiceRequestCard> createState() =>
//       _ProviderServiceRequestCardState();
// }
//
// class _ProviderServiceRequestCardState
//     extends State<ProviderServiceRequestCard> {
//   final int verified = storage.read('verified_provider');
//   final int offerCount = storage.read('offer_count') ?? 0;
//   final int providerId = storage.read('provider_id') ?? 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Card(
//         color: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: SizedBox(
//           width: MediaQuery.of(context).size.width * 0.9,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 16, bottom: 16, right: 8),
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.all(
//                     Radius.circular(16),
//                   ),
//                   child: CachedNetworkImage(
//                     imageUrl: widget.service.image!,
//                     height: 120,
//                     width: 100,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               '${widget.service.title!}',
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 color: MyColors.Darkest,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           Card(
//                             color: MyColors.cardPriceBackgroundColor,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16)),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 6, horizontal: 12),
//                               child: Text(
//                                 '${widget.service.price!} دينار',
//                                 style: const TextStyle(
//                                     fontSize: 12, color: MyColors.MainPrimary),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       SizedBoxedH8,
//                       Row(
//                         children: [
//                           SvgPicture.asset('assets/svg/request_calender.svg'),
//                           const SizedBox(width: 6),
//                           Expanded(
//                             child: Text(
//                               'تاريخ الطلب ${widget.service.date!}',
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 color: MyColors.textColor,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBoxedH8,
//                       Row(
//                         children: [
//                           Expanded(
//                             child: SizedBox(
//                               width: double.infinity,
//                               child: TextButton(
//                                 style: flatButtonPrimaryStyle,
//                                 onPressed: verified == 1
//                                     ? () async {
//                                         if (offerCount == 1) {
//                                           // Show confirmation dialog
//                                           final result =
//                                               await showDialog<String>(
//                                             context: context,
//                                             builder: (BuildContext context) {
//                                               return Directionality(
//                                                 textDirection:
//                                                     TextDirection.rtl,
//                                                 child: AlertDialog(
//                                                   title: Text(
//                                                       ' تنبيه  مشروع - ${widget.service.title}'),
//                                                   content: Text(
//                                                       'تملك حالياً عرض واحد فقط. هل ترغب بالانسحاب من باقي التقديمات أم شراء عروض إضافية؟'),
//                                                   actions: [
//                                                     TextButton(
//                                                       onPressed: () {
//                                                         Navigator.of(context)
//                                                             .pop('withdraw');
//                                                       },
//                                                       child: Text(
//                                                           'انسحاب من باقي المشاريع'),
//                                                     ),
//                                                     TextButton(
//                                                       onPressed: () {
//                                                         Navigator.of(context)
//                                                             .pop('purchase');
//                                                       },
//                                                       child: Text(
//                                                           'شراء عروض إضافية'),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               );
//                                             },
//                                           );
//
//                                           if (result == 'withdraw') {
//                                             // Delete pending offers
//                                             final response = await Provider.of<
//                                                         ProviderServicesProvider>(
//                                                     context,
//                                                     listen: false)
//                                                 .deletePendingOffers(
//                                                     providerId);
//
//                                             if (response.status ==
//                                                 ResponseStatus.success) {
//                                               Navigator.of(context).push(
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       RequestOfferProviderScreen(
//                                                     serviceDetails:
//                                                         widget.service,
//                                                   ),
//                                                 ),
//                                               );
//                                             } else {
//                                               ScaffoldMessenger.of(context)
//                                                   .showSnackBar(
//                                                 SnackBar(
//                                                   content: Text(response
//                                                           .errorMessage ??
//                                                       'حدث خطأ أثناء حذف العروض المعلقة'),
//                                                 ),
//                                               );
//                                             }
//                                           } else if (result == 'purchase') {
//                                             Navigator.of(context).push(
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     PackagesScreen(),
//                                               ),
//                                             );
//                                           }
//                                         } else {
//                                           Navigator.of(context).push(
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   RequestOfferProviderScreen(
//                                                 serviceDetails: widget.service,
//                                               ),
//                                             ),
//                                           );
//                                         }
//                                       }
//                                     : null,
//                                 child: Text(
//                                   'تقديم'.tr(),
//                                   style: const TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w900,
//                                       color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: SizedBox(
//                               width: double.infinity,
//                               child: TextButton(
//                                 style: flatButtonLightStyle,
//                                 onPressed: () async {
//                                   Navigator.of(context).push(
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           RequestDetailsProviderScreen(
//                                         loadedService: widget.service,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: Text(
//                                   'عرض تفاصيل'.tr(),
//                                   style: const TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w900,
//                                       color: MyColors.Darkest),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
