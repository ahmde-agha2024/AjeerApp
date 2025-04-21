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

class AllProvidersScreen extends StatefulWidget {
  @override
  State<AllProvidersScreen> createState() => _AllProvidersScreenState();
}

class _AllProvidersScreenState extends State<AllProvidersScreen> {
  bool _isDataFetched = false;
  ResponseHandler<List<ServiceProvider>>? _serviceProviders;

  @override
  void didChangeDependencies() {
    Provider.of<CustomerHomeProvider>(context, listen: false).fetchAllServiceProviders().then((value) {
      _serviceProviders = value;
      setState(() {
        _isDataFetched = true;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppbarTitle(
            title: 'Service Providers'.tr(), // TODO TRANSLATE
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
                                  'Try Again'.tr(), // TODO TRANSLATE
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isDataFetched = false;
                                  didChangeDependencies();
                                });
                              }),
                        )
                      ],
                    )
                  : Expanded(child: _buildListView(_serviceProviders!.response!)),
        ],
      ),
    );
  }

  Widget _buildListView(List<ServiceProvider> serviceProviders) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: serviceProviders.length,
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          return ProviderProfileCard(serviceProvider: serviceProviders[index]);
        },
      ),
    );
  }
}
