import 'package:ajeer/constants/my_colors.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/customer/home/customer_home_page_provider.dart';
import 'package:ajeer/models/customer/home/home_model.dart';
import 'package:ajeer/ui/screens/home_client/all_providers_screen.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../widgets/border_radius_card.dart';
import '../../widgets/home/appbar_home.dart';
import '../../widgets/home/background_appbar_home.dart';
import '../../widgets/home/carousel_slider_home.dart';
import '../../widgets/home/category_list_view.dart';
import '../../widgets/home/most_requested_list_view.dart';
import '../../widgets/home/providers_list_view_home.dart';
import '../../widgets/home/search_home.dart';
import '../../widgets/sized_box.dart';
import '../../widgets/title_section.dart';
import 'all_categories_screen.dart';
import 'top_selling_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFetched = false;
  ResponseHandler<CustomerHome>? _customerHome;

  Future<void> _refreshData() async {
    final fetchedData =
    await Provider.of<CustomerHomeProvider>(context, listen: false)
        .fetchCustomerHomePage();
    if (fetchedData.response != null) {
      _customerHome = fetchedData;
    }
    setState(() {
      _isFetched = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isFetched) {
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          BackgroundAppbarHome(
            imageAssetPath: 'assets/Icons/home_background.jpeg',
            //height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBoxedH16,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AppbarHome(),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SearchHome(),
                ),
                SizedBoxedH16,
                ClipRRect(
                  borderRadius: topBorderRadiusCard,
                  child: Card(
                    color: Colors.white,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: topBorderRadiusCard),
                    child: !_isFetched
                        ? loaderWidget(context, type: "customer_home")
                        : _customerHome!.status == ResponseStatus.success
                        ? RefreshIndicator(
                      onRefresh: _refreshData, // السحب للتحديث
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Filter sliders by type
                            if (_customerHome!.response!.sliders !=
                                null) ...[
                              // Show sliders with type "main"
                              if (_customerHome!.response!.sliders!
                                  .any((slider) =>
                              slider.type == "customer"))
                                CarouselSliderHome(
                                  slides: _customerHome!
                                      .response!.sliders
                                      .where((slider) =>
                                  slider.type == "customer")
                                      .toList(),
                                  catergoryTitle: _customerHome!
                                      .response!.categories,
                                ),
                            ],
                            SizedBoxedH16,
                            TitleSections(
                              title: 'Categories',
                              isViewAll: true,
                              onTapView: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllCategoriesScreen()));
                              },
                            ),
                            SizedBoxedH16,
                            CategoryListView(
                                categories: _customerHome!
                                    .response!.categories),
                            SizedBoxedH16,
                            TitleSections(
                              title: 'Most requested',
                              isViewAll: true,
                              onTapView: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TopSellingScreen()));
                              },
                            ),
                            SizedBoxedH8,
                            MostRequestedListView(
                                mostRequested: _customerHome!
                                    .response!.topSelling),
                            SizedBoxedH16,
                            SizedBoxedH16,
                            TitleSections(
                              title: 'Service Providers',
                              isViewAll: true,
                              onTapView: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllProvidersScreen()));
                              },
                            ),
                            // SizedBoxedH8,
                            ProvidersListViewHome(
                              serviceProviders: _customerHome!
                                  .response!.randomServiceProviders,
                              customer: _customerHome!.response!.user,
                            ),
                            SizedBoxedH24,
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Dear user, before contacting the technicians through the app, we would like to remind you of the importance of contracting within the app and avoiding any dealings with technicians outside it. This ensures your rights as a user and allows you to benefit from the advantages provided by the app.'
                                    .tr(),
                                style: const TextStyle(
                                  color: MyColors.Darkest,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBoxedH24,
                            SizedBoxedH24,
                          ],
                        ),
                      ),
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        errorWidget(context),
                        Builder(
                          builder: (context) => MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(8.0),
                            ),
                            color: MyColors.MainBulma,
                            onPressed: _refreshData,
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
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
