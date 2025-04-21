import 'package:ajeer/models/common/category_model.dart';
import 'package:flutter/material.dart';

import '../../screens/home_client/all_categories_screen.dart';
import '../single_category_card.dart';

class CategoryListView extends StatelessWidget {
  final List<Category> categories;

  const CategoryListView({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16),
      child: SizedBox(
        height: 300,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: 16,top: 10,bottom: 10,start: 10),
              child: SingleCategoryCard(
                title: categories[index].title,
                imagePath: categories[index].image,
                onTapClick: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AllCategoriesScreen(
                        scrollToCategory: categories[index].title,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
