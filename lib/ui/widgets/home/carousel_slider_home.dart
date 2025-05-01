import 'package:ajeer/models/common/category_model.dart';
import 'package:ajeer/models/customer/provider/slider_model.dart';
import 'package:ajeer/ui/screens/home_client/all_categories_screen.dart'
    show AllCategoriesScreen;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../constants/my_colors.dart';
import '../../screens/photo_zoom_screen.dart';

class CarouselSliderHome extends StatefulWidget {
  List<SliderModel> slides;
  List<Category>? catergoryTitle;

  CarouselSliderHome({super.key, required this.slides, this.catergoryTitle});

  @override
  _CarouselSliderHomeState createState() => _CarouselSliderHomeState();
}

class _CarouselSliderHomeState extends State<CarouselSliderHome> {
  int _currentSlide = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            viewportFraction: 0.92,
            enlargeCenterPage: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentSlide = index;
              });
            },
          ),
          items: widget.slides.map((slide) {
            return InkWell(
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => PhotoZoomScreen(
                //           imagePath: slide.image,
                //           userName: slide.title,
                //         )));
                if (slide.type == "customer")
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AllCategoriesScreen(
                        scrollToCategory: widget.catergoryTitle!
                            .firstWhere(
                              (category) => category.id == slide.categoryId,
                              orElse: () => widget.catergoryTitle!.first,
                            )
                            .title,
                      ),
                    ),
                  );
              },
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.88, // Ensure the child has a width
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      child: Stack(
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: slide.image,
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: 180,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                              color: MyColors.MainBulma,
                            )),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                              child: Text(
                                slide.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
              ),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.slides.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentSlide == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentSlide == index
                    ? MyColors.MainBulma
                    : MyColors.LightDark,
                borderRadius: _currentSlide == index
                    ? BorderRadius.circular(4)
                    : BorderRadius.circular(50),
                border: _currentSlide == index
                    ? Border.all(
                        color: MyColors.MainBulma,
                        width: 2,
                      )
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }
}
