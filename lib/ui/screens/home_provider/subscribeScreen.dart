import 'package:ajeer/constants/my_colors.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/general/about_app_controller.dart';
import 'package:ajeer/models/general/about_app_model.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/rendering.dart';

import '../../../NewDesign/plans.dart';
import '../../../controllers/service_provider/provider_subscriptions_provider.dart';
import '../../../models/customer/subscription_model.dart';
import '../../widgets/appbar_title.dart';
import '../../widgets/button_styles.dart';
import '../../widgets/sized_box.dart';

class SubScribeScreen extends StatefulWidget {
  const SubScribeScreen({super.key});

  @override
  State<SubScribeScreen> createState() => _SubScribeScreenState();
}

class _SubScribeScreenState extends State<SubScribeScreen> {
  ResponseHandler<SubscriptionResponse>? _responseHandler;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      Provider.of<ProviderSubscriptions>(context, listen: false)
          .fetchMySubscriptions()
          .then((value) {
        setState(() {
          _responseHandler = value;
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(title: 'إشتراكاتي'),
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? _buildShimmer()
              : _responseHandler == null ||
                      _responseHandler!.status == ResponseStatus.error
                  ? Center(child: Text('حدث خطأ أثناء جلب البيانات'))
                  : _responseHandler!.response == null ||
                          _responseHandler!.response!.data.isEmpty
                      ? Center(child: Text('لا يوجد اشتراك حالي'))
                      : _buildSubscriptionCards(
                          _responseHandler!.response!.data),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 80,
                        height: 18,
                        color: Colors.white,
                      ),
                      Container(
                        width: 50,
                        height: 18,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 38),
                  Container(width: 120, height: 16, color: Colors.white),
                  SizedBox(height: 12),
                  Container(width: 140, height: 16, color: Colors.white),
                  SizedBox(height: 12),
                  Container(width: 140, height: 16, color: Colors.white),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSubscriptionCards(List<Subscription> subscriptions) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: subscriptions.length,
      separatorBuilder: (_, __) => SizedBox(height: 30),
      itemBuilder: (context, index) {
        final subscription = subscriptions[index];
        return _buildSingleSubscriptionCard(subscription);
      },
    );
  }

  Widget _buildSingleSubscriptionCard(Subscription subscription) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          subscription.package.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.stars,
                            color: subscription.package.name == "فني محترف"
                                ? Color(0xFFEE9F07)
                                : subscription.package.name == "فني مميز"
                                    ? Color(0xFF719BF8)
                                    : Color(0xFF55AE40),
                            size: 14),
                      ],
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                      decoration: BoxDecoration(
                        color: subscription.isActive == true
                            ? Color(0xFFB6F2B2)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        subscription.isActive == true ? 'مفعل' : 'غير مفعل',
                        style: TextStyle(
                          color: subscription.isActive == true
                              ? Color(0xFF52A73E)
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 38),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('مدة الإشتراك:',
                        style: TextStyle(
                            color: Color(0xffA0A0A0),
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Text(
                        '${_getDurationInMonths(subscription.startDate.toString(), subscription.endDate.toString())} أشهر',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xff636363))),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('الأيام المتبقية:',
                        style: TextStyle(
                            color: Color(0xffA0A0A0),
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Text('${subscription.remainingDays.toString()} يوم',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xff636363))),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('تاريخ الإشتراك:',
                        style: TextStyle(
                            color: Color(0xffA0A0A0),
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Text(subscription.startDate.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xff636363))),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('تاريخ الانتهاء:',
                        style: TextStyle(
                            color: Color(0xffA0A0A0),
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Text(subscription.endDate.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xff636363))),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => PlansScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE04836),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(vertical: 18),
            ),
            child: Text(
              'الباقات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  int _getDurationInMonths(String start, String end) {
    try {
      final startDate = DateTime.parse(start);
      final endDate = DateTime.parse(end);
      return (endDate.difference(startDate).inDays / 30).round();
    } catch (e) {
      return 0;
    }
  }
}
