import 'package:ajeer/models/customer/service_provider_model.dart';
import 'package:ajeer/ui/screens/call%20screens/call_screens.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/get_storage.dart';
import '../constants/my_colors.dart';
import '../constants/utils.dart';
import '../controllers/common/auth_provider.dart';
import '../controllers/common/chat_provider.dart';
import '../controllers/customer/home/customer_home_page_provider.dart';
import '../models/common/chat_model.dart';
import '../models/customer/service_provider_details_model.dart';
import '../models/provider/home/provider_home_model.dart';
import '../ui/screens/home_client/projectForUserDetails.dart';
import '../ui/screens/messages_screen.dart';
import '../ui/screens/single_chat_screen.dart';
import '../ui/widgets/common/error_widget.dart';
import '../ui/widgets/common/loader_widget.dart';
import '../services/call_service.dart';
import '../ui/widgets/provider/dialogcall.dart';
import '../models/customer/service_model.dart';

class BlueProviderScreen extends StatefulWidget {
  BlueProviderScreen(
      {Key? key, required this.providerId, this.serviceProvider});

  final int providerId;
  final ServiceProvider? serviceProvider;

  @override
  State<BlueProviderScreen> createState() => _BlueProviderScreenState();
}

class _BlueProviderScreenState extends State<BlueProviderScreen> {
  ResponseHandler<ServiceProviderDetails>? serviceProviderDetails;
  late bool isClient;

  int? chatId;

  @override
  void didChangeDependencies() {
    Provider.of<CustomerHomeProvider>(context, listen: false)
        .fetchServiceProviderDetails(providerId: widget.providerId)
        .then((value) {
      setState(() {
        _isFetched = true;
        if (value.status == ResponseStatus.success) {
          serviceProviderDetails = value;
        }
      });
    });
    isClient = Provider.of<Auth>(context, listen: false).isClient;
    _fetchChatId();
    super.didChangeDependencies();
  }

  bool _isFetched = false;

  Future<void> _fetchChatId() async {
    if (isClient) {
      final response = await Provider.of<Chat>(context, listen: false)
          .fetchIdChatCstomerToProvider(pid: widget.providerId);
      if (response.status == ResponseStatus.success &&
          response.response != null) {
        setState(() {
          chatId = response.response;
        });
      }
    }
  }

  Widget specialBadge({
    required String text,
    required Color color,
    required Color borderColor,
    required List<BoxShadow> boxShadow,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.25,
      height: screenWidth * 0.08,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(screenWidth * 0.08),
        border: Border.all(
          color: borderColor,
          width: screenWidth * 0.01,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.035,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final services = serviceProviderDetails?.response?.services ?? [];
    final lastTwoServices =
    services.length >= 2 ? services.sublist(services.length - 2) : services;

    return Scaffold(
      body: !_isFetched
          ? loaderWidget(context)
          : serviceProviderDetails == null
          ? errorWidget(context)
          : serviceProviderDetails?.status == ResponseStatus.error
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          errorWidget(context),
          Builder(
            builder: (context) => MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
                color: MyColors.MainBulma,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.03),
                  child: Text(
                    'Try Again'.tr(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
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
          : serviceProviderDetails!.response!.subscription!.isNotEmpty
          ? Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                // Header background
                SizedBox(
                  height: screenHeight * 0.16,
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: serviceProviderDetails!
                            .response!
                            .subscription!
                            .last
                            .newPackage!
                            .name
                            .toString() ==
                            "فني مميز"
                            ? LinearGradient(
                          colors: [
                            Color(0xFF487AEB),
                            Color(0xFF487AEB)
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        )
                            : serviceProviderDetails!
                            .response!
                            .subscription!
                            .last
                            .newPackage!
                            .name
                            .toString() ==
                            "فني محترف"
                            ? LinearGradient(
                          colors: [
                            Color(0xFFEFA711),
                            Color(0xFFEFA711)
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        )
                            : LinearGradient(
                          colors: [
                            Color(0xFF55AE40),
                            Color(0xFF61D147)
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        )),
                    child: serviceProviderDetails!
                        .response!
                        .subscription!
                        .last
                        .newPackage!
                        .name
                        .toString() ==
                        "فني مميز"
                        ? Image.asset(
                      "assets/Icons/blueheader.png",
                      fit: BoxFit.cover,
                    )
                        : serviceProviderDetails!
                        .response!
                        .subscription!
                        .last
                        .newPackage!
                        .name
                        .toString() ==
                        "فني محترف"
                        ? Image.asset(
                      "assets/Icons/goldheader.png",
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      "assets/Icons/greenheader.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Main content
                Column(
                  children: [
                    SizedBox(height: screenHeight * 0.1),
                    // Profile image with badge
                    Center(
                      child: SingleChildScrollView(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Positioned(
                              child: Container(
                                width: screenWidth * 0.3,
                                height: screenWidth * 0.3,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white,
                                      width: screenWidth * 0.015),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.08),
                                      blurRadius: screenWidth * 0.03,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    fit: BoxFit.cover,
                                    serviceProviderDetails!
                                        .response!
                                        .image!,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: screenWidth * 0.02,
                              right: screenWidth * 0.005,
                              child: serviceProviderDetails!
                                  .response!
                                  .subscription!
                                  .last
                                  .newPackage!
                                  .name
                                  .toString() ==
                                  "فني مميز"
                                  ? Image.asset(
                                'assets/Icons/blue_star.png',
                                width: screenWidth * 0.08,
                                height: screenWidth * 0.08,
                              )
                                  : serviceProviderDetails!
                                  .response!
                                  .subscription!
                                  .last
                                  .newPackage!
                                  .name
                                  .toString() ==
                                  "فني محترف"
                                  ? Image.asset(
                                'assets/Icons/gold_star.png',
                                width: screenWidth * 0.08,
                                height: screenWidth * 0.08,
                              )
                                  : Image.asset(
                                'assets/Icons/green_star.png',
                                width: screenWidth * 0.08,
                                height: screenWidth * 0.08,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    // Name
                    Text(
                      serviceProviderDetails!.response!.name!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.055,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    // Specialties
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Badge
                    specialBadge(
                      text: serviceProviderDetails!.response!
                          .subscription!.last.newPackage!.name
                          .toString(),
                      color: serviceProviderDetails!
                          .response!
                          .subscription!
                          .last
                          .newPackage!
                          .name
                          .toString() ==
                          "فني مميز"
                          ? const Color(0xFF719BF8)
                          : serviceProviderDetails!
                          .response!
                          .subscription!
                          .last
                          .newPackage!
                          .name
                          .toString() ==
                          "فني محترف"
                          ? Color(0xFFEFA711)
                          : Color(0xFF55AE40),
                      borderColor: serviceProviderDetails!
                          .response!
                          .subscription!
                          .last
                          .newPackage!
                          .name
                          .toString() ==
                          "فني مميز"
                          ? const Color(0xFF749DF9)
                          : serviceProviderDetails!
                          .response!
                          .subscription!
                          .last
                          .newPackage!
                          .name
                          .toString() ==
                          "فني محترف"
                          ? Color(0xFFF6CE40)
                          : Color(0xFF61D147),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF5B9EFF)
                              .withOpacity(0.35),
                          blurRadius: screenWidth * 0.1,
                          spreadRadius: screenWidth * 0.025,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    // Stats row
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.08),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          _StatItem(
                            image: "assets/Icons/star.png",
                            value: serviceProviderDetails!
                                .response!.stars
                                .toString(),
                            label: 'التقييم',
                          ),
                          Container(
                            height: screenHeight * 0.05,
                            width: screenWidth * 0.003,
                            color: Colors.grey[300],
                          ),
                          _StatItem(
                            image:
                            "assets/Icons/projectdone.png",
                            value: serviceProviderDetails!
                                .response!
                                .services!
                                .length
                                .toString() ??
                                "0",
                            label: 'المشاريع المنجزة',
                          ),
                          Container(
                            height: screenHeight * 0.05,
                            width: screenWidth * 0.003,
                            color: Colors.grey[300],
                          ),
                          _StatItem(
                            image:
                            "assets/Icons/personalcard.png",
                            value:
                            '+${serviceProviderDetails!.response!.experience}',
                            label: 'سنوات الخبرة',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // About section
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.06),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'نبذة عني',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Text(
                            serviceProviderDetails!
                                .response!.about ??
                                'about is empty',
                            maxLines: 4,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    // Recent works
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          lastTwoServices.length == 0
                              ? SizedBox()
                              : Text(
                            'آخر الأعمال',
                            style: TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.002),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02),
                      child: Row(
                        children: List.generate(
                          lastTwoServices.length,
                              (index) => Expanded(
                            child: _WorkCard(
                                service:
                                lastTwoServices[index]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    // Bottom buttons
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                showCallBottomSheet(
                                    context,
                                    serviceProviderDetails
                                        ?.response?.phone);
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(
                                    screenWidth * 0.4,
                                    screenHeight * 0.06),
                                backgroundColor:
                                const Color(0xFFE04836),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      screenWidth * 0.04),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02),
                              ),
                              child: Text(
                                'اتصال',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final data =
                                storage.read("user_data");
                                final customer = data != null
                                    ? Customer.fromJson(data)
                                    : null;
                                if (chatId != null) {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SingleChatScreen(
                                                chatHead: ChatHead(
                                                    id:
                                                    chatId,
                                                    customer:
                                                    customer,
                                                    provider:
                                                    widget
                                                        .serviceProvider),
                                              )));
                                } else {
                                  await _fetchChatId();
                                  setState(() {
                                    chatId = chatId;
                                  });
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SingleChatScreen(
                                                chatHead: ChatHead(
                                                    id:
                                                    chatId,
                                                    customer:
                                                    customer,
                                                    provider:
                                                    widget
                                                        .serviceProvider),
                                              )));
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(
                                    screenWidth * 0.4,
                                    screenHeight * 0.06),
                                side: BorderSide(
                                    color: Color(0xFFE04836),
                                    width: screenWidth * 0.002),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      screenWidth * 0.04),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02),
                              ),
                              child: Text(
                                'دردشة',
                                style: TextStyle(
                                  color: Color(0xFFE04836),
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
          : Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                // Header background
                SizedBox(
                  height: screenHeight * 0.16,
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF55AE40),
                            Color(0xFF61D147)
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        )),
                    child: Image.asset(
                      "assets/Icons/greenheader.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Main content
                Column(
                  children: [
                    SizedBox(height: screenHeight * 0.1),
                    // Profile image with badge
                    Center(
                      child: SingleChildScrollView(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Positioned(
                              child: Container(
                                width: screenWidth * 0.3,
                                height: screenWidth * 0.3,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white,
                                      width: screenWidth * 0.015),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.08),
                                      blurRadius: screenWidth * 0.03,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    fit: BoxFit.cover,
                                    serviceProviderDetails!
                                        .response!
                                        .image!,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: screenWidth * 0.02,
                              right: screenWidth * 0.005,
                              child: Image.asset(
                                'assets/Icons/green_star.png',
                                width: screenWidth * 0.08,
                                height: screenWidth * 0.08,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    // Name
                    Text(
                      serviceProviderDetails!.response!.name!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.055,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    // Specialties
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    serviceProviderDetails!.response!
                        .subscription!.isNotEmpty
                        ? specialBadge(
                      text: serviceProviderDetails!
                          .response!
                          .subscription!
                          .last
                          .newPackage!
                          .name
                          .toString(),
                      color: Color(0xFF55AE40),
                      borderColor: Color(0xFF61D147),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF5B9EFF)
                              .withOpacity(0.35),
                          blurRadius: screenWidth * 0.1,
                          spreadRadius: screenWidth * 0.025,
                        ),
                      ],
                    )
                        : SizedBox(),
                    SizedBox(height: screenHeight * 0.04),
                    // Stats row
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.08),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          _StatItem(
                            image: "assets/Icons/star.png",
                            value: serviceProviderDetails!
                                .response!.stars
                                .toString(),
                            label: 'التقييم',
                          ),
                          Container(
                            height: screenHeight * 0.05,
                            width: screenWidth * 0.003,
                            color: Colors.grey[300],
                          ),
                          _StatItem(
                            image:
                            "assets/Icons/projectdone.png",
                            value: serviceProviderDetails!
                                .response!
                                .services!
                                .length
                                .toString() ??
                                "0",
                            label: 'المشاريع المنجزة',
                          ),
                          Container(
                            height: screenHeight * 0.05,
                            width: screenWidth * 0.003,
                            color: Colors.grey[300],
                          ),
                          _StatItem(
                            image:
                            "assets/Icons/personalcard.png",
                            value:
                            '+${serviceProviderDetails!.response!.experience}',
                            label: 'سنوات الخبرة',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // About section
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.06),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'نبذة عني',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Text(
                            serviceProviderDetails!
                                .response!.about ??
                                'about is empty',
                            maxLines: 4,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    // Recent works
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          lastTwoServices.length == 0
                              ? SizedBox()
                              : Text(
                            'آخر الأعمال',
                            style: TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.002),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02),
                      child: Row(
                        children: List.generate(
                          lastTwoServices.length,
                              (index) => Expanded(
                            child: _WorkCard(
                                service:
                                lastTwoServices[index]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    // Bottom buttons
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                showCallBottomSheet(
                                    context,
                                    serviceProviderDetails
                                        ?.response?.phone);
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(
                                    screenWidth * 0.4,
                                    screenHeight * 0.06),
                                backgroundColor:
                                const Color(0xFFE04836),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      screenWidth * 0.04),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02),
                              ),
                              child: Text(
                                'اتصال',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final data =
                                storage.read("user_data");
                                final customer = data != null
                                    ? Customer.fromJson(data)
                                    : null;
                                if (chatId != null) {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SingleChatScreen(
                                                chatHead: ChatHead(
                                                    id:
                                                    chatId,
                                                    customer:
                                                    customer,
                                                    provider:
                                                    widget
                                                        .serviceProvider),
                                              )));
                                } else {
                                  await _fetchChatId();
                                  setState(() {
                                    chatId = chatId;
                                  });
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SingleChatScreen(
                                                chatHead: ChatHead(
                                                    id:
                                                    chatId,
                                                    customer:
                                                    customer,
                                                    provider:
                                                    widget
                                                        .serviceProvider),
                                              )));
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(
                                    screenWidth * 0.4,
                                    screenHeight * 0.06),
                                side: BorderSide(
                                    color: Color(0xFFE04836),
                                    width: screenWidth * 0.002),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      screenWidth * 0.04),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02),
                              ),
                              child: Text(
                                'دردشة',
                                style: TextStyle(
                                  color: Color(0xFFE04836),
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget for stats row
class _StatItem extends StatelessWidget {
  final String image;
  final String value;
  final String label;

  const _StatItem(
      {required this.image, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.045,
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Image.asset(
              image,
              width: screenWidth * 0.06,
              height: screenWidth * 0.06,
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.015),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: screenWidth * 0.035,
          ),
        ),
      ],
    );
  }
}

// Widget for recent work card
class _WorkCard extends StatelessWidget {
  final ProviderService service;

  const _WorkCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProjectForUserDetails(
                  service: convertProviderServiceToService(service),
                )));
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.045)),
        elevation: 1,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(screenWidth * 0.035)),
                  child: CachedNetworkImage(
                    imageUrl: service.image ?? '',
                    height: screenHeight * 0.15,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Center(
                  child: Text(
                    service.title ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.06,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Center(
                  child: Text(
                    service.content ?? '',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Color(0xff9F9F9F),
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
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

Service convertProviderServiceToService(ProviderService providerService) {
  return Service(
      id: providerService.id,
      title: providerService.title,
      content: providerService.content,
      image: providerService.image,
      date: providerService.date,
      category: providerService.category);
}
