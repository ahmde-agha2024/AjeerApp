import 'package:ajeer/constants/my_colors.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/customer/home/customer_home_page_provider.dart';
import 'package:ajeer/models/customer/service_provider_model.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../widgets/home/provider_profile_card.dart';
import '../../widgets/my_requests/appbar_my_requests.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  bool _isFetched = false;

  ResponseHandler<List<ServiceProvider>> favoriteProviders =
      ResponseHandler(status: ResponseStatus.error);

  @override
  void didChangeDependencies() {
    if (!_isFetched) {
      _fetchFavoriteProviders();
    }
    super.didChangeDependencies();
  }

  Future<void> _fetchFavoriteProviders() async {
    final fetchedData =
        await Provider.of<CustomerHomeProvider>(context, listen: false)
            .fetchFavoriteServiceProviders();
    setState(() {
      favoriteProviders = fetchedData;
      _isFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 46),
          AppbarHomeCustom(
            title: 'المفضلة',
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchFavoriteProviders, // السحب لتحديث البيانات
              child: !_isFetched
                  ? loaderWidget(context)
                  : favoriteProviders.status == ResponseStatus.error
                      ? _buildErrorWidget()
                      : (favoriteProviders.response == null ||
                              favoriteProviders.response!.isEmpty)
                          ? _buildEmptyState()
                          : _buildListView(favoriteProviders.response!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                  _fetchFavoriteProviders();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/lottie/empty_lottie.json',
                    height: 160, width: 160),
                const SizedBox(height: 16),
                Text(
                  'No Selected Favourites , Favourite Will Appear Here'.tr(),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MyColors.Darkest),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListView(List<ServiceProvider> serviceProviders) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: serviceProviders.length,
        itemBuilder: (ctx, index) {
          return ProviderProfileCard(serviceProvider: serviceProviders[index]);
        },
      ),
    );
  }
}
