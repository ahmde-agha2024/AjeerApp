import 'package:ajeer/constants/my_colors.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/customer/home/customer_home_page_provider.dart';
import 'package:ajeer/models/customer/service_provider_model.dart';
import 'package:ajeer/ui/widgets/appbar_title.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:ajeer/ui/widgets/home/provider_profile_card.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../widgets/home/provider_profile_card_all.dart';

class AllProvidersScreen extends StatefulWidget {
  @override
  State<AllProvidersScreen> createState() => _AllProvidersScreenState();
}

class _AllProvidersScreenState extends State<AllProvidersScreen> {
  bool _isDataFetched = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  List<ServiceProvider> _allServiceProviders = [];
  ResponseHandler<List<ServiceProvider>>? _serviceProviders;

  @override
  void didChangeDependencies() {
    _fetchData();
    super.didChangeDependencies();
  }

  Future<void> _fetchData({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      setState(() {
        _isDataFetched = false;
        _currentPage = 1;
        _allServiceProviders = [];
      });
    }

    final response = await Provider.of<CustomerHomeProvider>(context, listen: false)
        .fetchAllServiceProviders(pageNumber: _currentPage, pageSize: _pageSize);

    if (response.status == ResponseStatus.success) {
      setState(() {
        if (isLoadMore) {
          _allServiceProviders.addAll(response.response!);
        } else {
          _allServiceProviders = response.response!;
        }
        _serviceProviders = response;
        _isDataFetched = true;
        _isLoadingMore = false;
      });
    } else {
      setState(() {
        _serviceProviders = response;
        _isDataFetched = true;
        _isLoadingMore = false;
    });
    }
  }

  Future<void> _loadMore() async {
    if (!_isLoadingMore && _serviceProviders?.status == ResponseStatus.success) {
      setState(() {
        _isLoadingMore = true;
        _currentPage++;
      });
      await _fetchData(isLoadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppbarTitle(
            title: 'Service Providers'.tr(),
          ),
          !_isDataFetched
              ? loaderWidget(context)
              : _serviceProviders!.status == ResponseStatus.error
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
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                child: Text(
                                  'Try Again'.tr(),
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                              onPressed: () {
                                _fetchData();
                              }),
                        )
                      ],
                    )
                  : Expanded(child: _buildListView(_allServiceProviders)),
        ],
      ),
    );
  }

  Widget _buildListView(List<ServiceProvider> serviceProviders) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: serviceProviders.length + (_isLoadingMore ? 1 : 0),
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          if (index == serviceProviders.length) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(MyColors.MainBulma),
                  strokeWidth: 3,
                ),
              ),
            );
          }

          if (index == serviceProviders.length - 1 && !_isLoadingMore) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _loadMore();
            });
          }

          return ProviderProfileCardAll(serviceProvider: serviceProviders[index]);
        },
      ),
    );
  }
}
