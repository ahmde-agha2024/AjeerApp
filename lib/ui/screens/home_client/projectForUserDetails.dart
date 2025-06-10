import 'package:ajeer/constants/get_storage.dart';
import 'package:ajeer/models/customer/service_model.dart';
import 'package:ajeer/ui/screens/home_client/projectForUserOffersShow.dart';
import 'package:ajeer/ui/screens/home_client/testUserCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../constants/utils.dart';
import '../../../controllers/common/auth_provider.dart';
import '../../../controllers/common/chat_provider.dart';
import '../../../controllers/service_provider/provider_offers_provider.dart';
import '../../../models/common/chat_model.dart';
import '../../widgets/provider/dialogcall.dart';
import '../single_chat_screen.dart';

class ProjectForUserDetails extends StatefulWidget {
  ProjectForUserDetails({required this.service, Key? key}) : super(key: key);
  final Service service;

  @override
  State<ProjectForUserDetails> createState() => _ProjectForUserDetailsState();
}

class _ProjectForUserDetailsState extends State<ProjectForUserDetails> {
  late int daysAgo;
  String? date1;
  late bool isClient;
  final TextEditingController _commentController = TextEditingController();
  String? _accessToken;
  int? chatId;

  @override
  void initState() {
    super.initState();
    daysAgo = _calculateDaysAgo(widget.service.date);
    isClient = Provider.of<Auth>(context, listen: false).isClient;
    _fetchChatId();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  int _calculateDaysAgo(String? dateString) {
    if (dateString == null) return 0;
    try {
      // صيغة التاريخ: Wed, 26 Feb. 2025
      final DateFormat formatter = DateFormat('EEE, dd MMM. yyyy', 'en');
      DateTime serviceDate = formatter.parse(dateString);
      DateTime now = DateTime.now();
      return now
          .difference(serviceDate)
          .inDays;
    } catch (e) {
      return 0;
    }
  }

  String convertDateToArabic(String dateString) {
    try {
      // تأكد من أن المتغير String ثم نظّف التنسيق
      String cleanDate = dateString.toString().replaceAll('.', '').trim();

      // تحويل إلى كائن DateTime
      DateTime date = DateFormat('EEE, dd MMM yyyy', 'en').parse(cleanDate);

      // تنسيق النتيجة بالعربية
      String dayName = DateFormat.EEEE('ar').format(date);
      String formattedDate = DateFormat('d/M/yyyy', 'en').format(date);
      date1 = formattedDate;
      return '$dayName $formattedDate';
    } catch (e) {
      return 'تاريخ غير صالح';
    }
  }

  Future<void> _fetchChatId() async {
    if (!isClient) {
      final response = await Provider.of<Chat>(context, listen: false).fetchIdChat(cid: widget.service.customer!.id);
      if (response.status == ResponseStatus.success && response.response != null) {
        setState(() {
          chatId = response.response;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {

    // Example data, replace with your actual data
    final String imageUrl = widget.service.image!;
    // final String price = widget.service.price!;
    final String serviceTitle = widget.service.title!;
    final String? category = widget.service.category?.title ?? "";
    final String? city = widget.service.userAddress?.region?.title! ?? "";
    final String date = widget.service.date! ?? "";
    final String description = widget.service.content! ?? "";

    return Scaffold(
      backgroundColor: Color(0xffFBFBFB),
      body: Column(
        children: [
          Stack(
            children: [
              Image.network(
                imageUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 50,
                right: 24,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/Icons/IconProjectUser.png',
                    width: 35,
                    height: 35,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 47,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          serviceTitle,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xff424242)),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 20, color: Color(0xffE04836)),
                          SizedBox(width: 4),
                          Text(
                            'منذ $daysAgo يوم',
                            style: TextStyle(
                              color: Color(0xff9F9F9F),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    category!,
                    style: TextStyle(
                        color: Color(0xff77838F),
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'معلومات عن الخدمة',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 21),
                  Row(
                    children: [
                      const Text('المدينة',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          )),
                      Spacer(),
                      Text(
                        city ?? "طرابلس",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff77838F)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 21),
                  Row(
                    children: [
                      const Text('تاريخ الخدمة: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          )),
                      Spacer(),
                      Text(
                        convertDateToArabic(date),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff77838F)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'حول المشكلة',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 11),
                  Text(
                    description,
                    style: TextStyle(
                      color: Color(0xff9F9F9F),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffDD5B4B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () async {
                            if (isClient) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProjectForUserOffersShow(
                                              service: widget.service,
                                              catgory: widget.service.category!
                                                  .title,
                                              date: date1!)));
                            } else {
                              final verified = storage.read("verified_provider");

                              if(verified==1){
                                final result = await showModalBottomSheet(
                                  backgroundColor: Colors.white,
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                  ),
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery
                                            .of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      child: _buildBottomSheetContent(context),
                                    );
                                  },
                                );
                                if (result == 'success') {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => OfferSuccessPage()),
                                  );
                                } else if (result == "apply") {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(builder: (_) => OfferSuccessPage()),
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(
                                          "لقد قمت بالتقديم مسبفا")));
                                  // );
                                } else {
                                  result != null
                                      ? ScaffoldMessenger
                                      .of(context)
                                      .showSnackBar(
                                      SnackBar(content: Text("$result")))
                                      : null;
                                }
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(
                                        "لم يتم تأكيد حسابك بعد")));
                              }

                            }
                          },
                          child: isClient
                              ? Text(
                            'تصفح العروض (${widget.service.offers?.length
                                .toString()})',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          )
                              : Text(
                            'أستظيع تنفيذ المشروع',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                isClient ? SizedBox() : SizedBox(width: 18,),
                isClient ? SizedBox() : InkWell(onTap: ()async{

                  if (chatId != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SingleChatScreen(
                          chatHead: ChatHead(
                            id: chatId,
                            customer: widget.service.customer,
                            provider: widget.service.provider
                          ),
                          service: widget.service,
                        )));
                  } else {
                    await _fetchChatId();
                    setState(() {
                      chatId = chatId;
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SingleChatScreen(
                          chatHead: ChatHead(
                              id: chatId,
                              customer: widget.service.customer,
                              provider: widget.service.provider
                          ),
                          service: widget.service,
                        )));
                  }
                }, child: Image.asset(
                  "assets/Icons/chatIconForProject.png", width: 47,
                  height: 47,)),
                isClient ? SizedBox() : SizedBox(width: 18,),
                isClient ? SizedBox() : InkWell(
                  onTap: (){
                    Navigator.pop(context);

                    showCallBottomSheet(
                        context,
                        widget.service.customer!.phone);
                  },
                  child: Image.asset(
                    "assets/Icons/callIconForProject.png", width: 47,
                    height: 47,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'اضافة تعليق',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xff181829),
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close, size: 32, color: Color(0xff181829)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffF7F8FA),
              borderRadius: BorderRadius.circular(32),
            ),
            child: TextField(
              controller: _commentController,
              maxLines: 4,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'اكتب تعليق حول الخدمة (إختياري)....',
                hintStyle: TextStyle(
                  color: Color(0xffC6C6C8),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffDD5B4B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onPressed: () async {
                ResponseHandler response =
                await Provider.of<ProviderOffersProvider>(context,
                    listen: false)
                    .createOfferForServiceRequest(
                  serviceId: widget.service.id!,
                  content: _commentController.text,
                );

                if (response.status == ResponseStatus.success) {
                  Navigator.of(context).pop("success");
                } else if (response.errorMessage != null) {
                  Navigator.of(context).pop(response.errorMessage);
                } else {
                  Navigator.of(context).pop("apply");
                }
              },
              child: Text(
                'التقديم على المشروع',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OfferSuccessPage extends StatefulWidget {
  const OfferSuccessPage({Key? key}) : super(key: key);

  @override
  State<OfferSuccessPage> createState() => _OfferSuccessPageState();
}

class _OfferSuccessPageState extends State<OfferSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFBFBFB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Color(0xffE04836),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_rounded, color: Colors.white, size: 100),
            ),
            SizedBox(height: 48),
            Text(
              'لقد تم ارسال طلبك',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'سيصلك اشعار في حالة الموافقة على عرضك',
              style: TextStyle(
                color: Color(0xff181829),
                fontSize: 14,
                //fontWeight: FontWeight.,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 41),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: Image.asset(
                "assets/Icons/icon-park-solid_back.png",
                width: 14,
                height: 14,
              ),
              iconAlignment: IconAlignment.end,
              label: Text(
                'الرجوع إلى الرئيسية',
                style: TextStyle(
                  color: Color(0xffC6C6C8),
                  //fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
