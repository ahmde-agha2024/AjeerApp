import 'package:ajeer/models/customer/service_provider_model.dart';
import 'package:flutter/material.dart';

import 'provider_profile_card.dart';

class ProvidersListViewHome extends StatelessWidget {
  List<ServiceProvider> serviceProviders;
   ProvidersListViewHome({super.key, required this.serviceProviders});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16),
      child: SizedBox(
        height: 140,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: serviceProviders.length,
          itemBuilder: (ctx, index) {
            return ProviderProfileCard(serviceProvider: serviceProviders[index]);
          },
        ),
      ),
    );
  }
}
