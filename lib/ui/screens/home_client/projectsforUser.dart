import 'package:ajeer/ui/screens/home_client/projectForUserDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
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

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
