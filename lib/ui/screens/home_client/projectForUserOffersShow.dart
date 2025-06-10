import 'package:ajeer/models/customer/service_model.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';


import '../../../NewDesign/blue_Provider.dart';
import '../../../constants/my_colors.dart';
import '../../widgets/my_requests/appbar_my_requests.dart';
import '../../widgets/sized_box.dart';
import '../provider_details_screen.dart';

class ProviderOffer {
  final String name;
  final String job;
  final double rating;
  final String duration;
  final String price;
  final String imageUrl;

  ProviderOffer({
    required this.name,
    required this.job,
    required this.rating,
    required this.duration,
    required this.price,
    required this.imageUrl,
  });
}

class ProjectForUserOffersShow extends StatelessWidget {
  final Service service;
  final String catgory;
  final String date;

  const ProjectForUserOffersShow(
      {Key? key,
      required this.service,
      required this.catgory,
      required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFBFBFB),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/Icons/IconProjectUser.png',
                    width: 35,
                    height: 35,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "العروض",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xff1F1F1F)),
                ),
              ],
            ),
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
          if (service.offers == null || service.offers!.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/Icons/0ffersIcons.png',
                      height: 180, width: 180),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد عروض في الانتظار حالياً !',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: MyColors.Darkest),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                // shrinkWrap: true,
                //physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: service.offers!.length,
                itemBuilder: (context, index) {
                  final offer = service.offers![index];
                  final provider = offer.provider;
                  if (provider == null)
                    return SizedBox(); // skip if no provider

                  return OfferCard(
                    name: provider.name ?? "بدون اسم",
                    job: catgory ?? "بدون مهنة",
                    rating: provider.stars!,
                    duration: date,
                    price: offer.price ?? 0.0,
                    imageUrl: provider.image ?? "",
                    id: provider.id,
                    date: date,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final String name;
  final String job;
  final double rating;
  final String duration;
  final double price;
  final String imageUrl;
  final int id;
  final String date;

  const OfferCard({
    Key? key,
    required this.name,
    required this.job,
    required this.rating,
    required this.duration,
    required this.price,
    required this.imageUrl,
    required this.id,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              // BoxShadow(
              //   color: Colors.black.withOpacity(0.18),
              //   blurRadius: 32,
              //   offset: const Offset(0, 8),
              // ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // معلومات المزود وكل التفاصيل (يسار)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // التقييم في الأعلى يسار
                          Row(
                            children: [

                              const Icon(Icons.star,
                                  color: Color(0xffFFC107), size: 11),
                              const SizedBox(width: 4),
                              Text(
                                '(${rating.toStringAsFixed(1)})',
                                style: TextStyle(
                                  color: Color(0xff77838F),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),
                              ),
                              Spacer(),
                              Text(name.length<=10?
                              name:name.substring(0,10),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),

                            ],
                          ),

                          Align(
                            alignment: Alignment.topRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [

                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  job,
                                  style: TextStyle(
                                    color: Color(0xff9F9F9F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14,),
                          // تفاصيل التنفيذ والسعر في المنتصف
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                date,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                ': تاريخ التقديم',
                                style: TextStyle(
                                  color: Color(0xff77838F),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(Icons.access_time,
                                  color: Color(0xffE04836), size: 18),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'دينار',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                price.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                ': السعر',
                                style: TextStyle(
                                  color: Color(0xff77838F),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.wallet,
                                color: Color(0xffE04836),
                                size: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // صورة المزود تغطي كامل ارتفاع البطاقة (يمين)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(28),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                    ),
                    child: Image.network(
                      imageUrl,
                      width: 118,
                       height: 132,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              // زر عرض الملف
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xffE04836),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlueProviderScreen(
                                  providerId: id,
                                )));
                  },
                  child: Text(
                    'عرض الملف',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
