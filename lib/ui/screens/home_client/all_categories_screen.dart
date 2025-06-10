import 'package:ajeer/constants/my_colors.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/customer/home/customer_home_page_provider.dart';
import 'package:ajeer/models/common/category_model.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../widgets/appbar_title.dart';
import '../../widgets/home/allcategory.dart';
import '../../widgets/single_category_card.dart';
import '../../widgets/sized_box.dart';
import '../../widgets/title_section.dart';
import '../single_category_screen.dart';

class AllCategoriesScreen extends StatefulWidget {
  final String? scrollToCategory;

  const AllCategoriesScreen({Key? key, this.scrollToCategory})
      : super(key: key);

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  ResponseHandler<List<Category>>? categoriesList;
  bool _isFetched = false;
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _categoryKeys = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!_isFetched) {
      Provider.of<CustomerHomeProvider>(context, listen: false)
          .fetchCategories()
          .then((value) {
        setState(() {
          _isFetched = true;
          if (value.status == ResponseStatus.success) {
            categoriesList = value;

            for (var category in categoriesList!.response!) {
              _categoryKeys[category.title!] = GlobalKey();
            }

            if (widget.scrollToCategory != null) {
              _scrollToCategory(widget.scrollToCategory!);
            }
          }
        });
      });
    }
    super.didChangeDependencies();
  }

  void _scrollToCategory(String categoryTitle) {
    final key = _categoryKeys[categoryTitle];

    if (key != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (key.currentContext != null) {
          final renderObject =
              key.currentContext!.findRenderObject() as RenderBox;
          final offset =
              renderObject.localToGlobal(Offset.zero, ancestor: null);

          _scrollController.animateTo(
            _scrollController.offset + offset.dy - kToolbarHeight - 32,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(title: 'All Categories'),
      backgroundColor: Colors.white,
      body: !_isFetched
          ? loaderWidget(context)
          : categoriesList!.status == ResponseStatus.error
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    errorWidget(context),
                    Builder(
                      builder: (context) => MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          color: MyColors.MainBulma,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            child: Text(
                              'Try Again'.tr(), // TODO TRANSLATE
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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
              : ListView(
                  controller: _scrollController,
                  children: [
                    Divider(
                      color: Colors.grey.withOpacity(0.1),
                      thickness: 10,
                    ),
                    SizedBoxedH16,
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categoriesList!.response!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final category = categoriesList!.response![index];
                          return Column(
                            key: _categoryKeys[
                                category.title], // استخدام المفتاح هنا
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Card(
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 8),
                                    child: TitleSections(
                                      title: category.title,
                                      isViewAll: false,
                                      onTapView: () {},
                                    ),
                                  ),
                                ),
                              ),
                              SizedBoxedH16,
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    childAspectRatio: 0.6,
                                  ),
                                  itemCount:
                                      category.subCategories?.length ?? 0,
                                  shrinkWrap: true,
                                  itemBuilder: (context, subIndex) {
                                    final subCategory =
                                        category.subCategories![subIndex];
                                    return allCategory(
                                      title: subCategory.title,
                                      imagePath: subCategory.image,
                                      onTapClick: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SingleCategoryScreen(
                                              category: subCategory,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              SizedBoxedH16,
                            ],
                          );
                        }),
                  ],
                ),
    );
  }
}
