import 'package:ajeer/models/customer/service_provider_model.dart';
import 'package:flutter/material.dart';

import '../../../models/auth/customer/user_model.dart';
import 'provider_profile_card.dart';

class ProvidersListViewHome extends StatelessWidget {
  List<ServiceProvider> serviceProviders;
  Customer customer;

   ProvidersListViewHome({super.key, required this.serviceProviders,required this.customer});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16,top: 0,),
      child: Container(
        color: Colors.white,
        child: SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: serviceProviders.length,
            itemBuilder: (ctx, index) {
              return ProviderProfileCard(serviceProvider: serviceProviders[index],);
            },
          ),
        ),
      ),
    );
  }
}


