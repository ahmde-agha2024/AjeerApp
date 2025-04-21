import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/customer/home/customer_home_page_provider.dart';
import 'package:ajeer/models/common/category_model.dart';
import 'package:ajeer/models/customer/service_provider_model.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../constants/my_colors.dart';
import '../widgets/appbar_title.dart';
import '../widgets/home/provider_profile_card.dart';

class SingleCategoryScreen extends StatefulWidget {
  final Category category;

  const SingleCategoryScreen({super.key, required this.category});

  @override
  State<SingleCategoryScreen> createState() => _SingleCategoryScreenState();
}

class _SingleCategoryScreenState extends State<SingleCategoryScreen>
    with SingleTickerProviderStateMixin {
  bool _isFetched = false;
  ResponseHandler<List<ServiceProvider>>? serviceProviders;
  late TabController _tabController;

  @override
  void didChangeDependencies() {
    Provider.of<CustomerHomeProvider>(context, listen: false)
        .fetchSubCategoryProviders(categoryId: widget.category.id)
        .then((value) {
      setState(() {
        _isFetched = true;
        if (value.status == ResponseStatus.success) {
          serviceProviders = value;
        }
      });
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {}); // Force rebuild when tab changes
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildCategoryItem(String categoryName, int index) {
    bool isSelected = _tabController.index == index;
    return ChoiceChip(
      label: Text(categoryName),
      selected: isSelected,
      checkmarkColor: Colors.white,
      onSelected: (bool selected) {
        _tabController.animateTo(index);
      },
      selectedColor: MyColors.MainBulma,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isFetched
          ? loaderWidget(context)
          : serviceProviders!.status == ResponseStatus.error
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
                              'Try Again'.tr(),
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
              : Column(
                  children: [
                    AppbarTitle(
                      title: widget.category!.title,
                    ),
                    // Container(
                    //   color: MyColors.LightBackgroundGrey.withOpacity(0.3),
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 8),
                    //     child: TabBar(
                    //       controller: _tabController,
                    //       isScrollable: true,
                    //       indicatorSize: TabBarIndicatorSize.label,
                    //       dividerColor: Colors.transparent,
                    //       indicatorColor: Colors.transparent,
                    //       padding: EdgeInsets.zero,
                    //       indicatorPadding: EdgeInsets.zero,
                    //       labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                    //       tabAlignment: TabAlignment.start,
                    //       tabs: [
                    //         _buildCategoryItem('الكل', 0),
                    //         _buildCategoryItem('إصلاحات', 1),
                    //         _buildCategoryItem('صيانة', 2),
                    //         _buildCategoryItem('تنظيف', 3),
                    //         _buildCategoryItem('أخري', 4),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildListView(),
                          _buildListView(),
                          _buildListView(),
                          _buildListView(),
                          _buildListView(),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  _buildListView() {
    if (serviceProviders!.response!.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/empty_lottie.json', height: 200),
          Text('No Providers Found'.tr()),
        ],
      );
    } else {
      return ListView.builder(
        itemCount: serviceProviders!.response!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ProviderProfileCard(
              serviceProvider: serviceProviders!.response![index],
            ),
          );
        },
      );
    }
  }
}
