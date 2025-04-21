import 'package:ajeer/models/customer/service_provider_model.dart';
import 'package:ajeer/ui/screens/provider_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../constants/my_colors.dart';

class MostRequestedListView extends StatelessWidget {
  List<ServiceProvider> mostRequested;

  MostRequestedListView({super.key, required this.mostRequested});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16),
      child: SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: mostRequested.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ProviderDetailsScreen(providerId: mostRequested[index].id),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Stack(
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: mostRequested[index].image ?? 'IMAGE', // TODO: Add Default image
                                    height: 110,
                                    width: 110,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Positioned(
                                //   top: 8,
                                //   left: 8,
                                //   child: Card(
                                //     color: MyColors.MainPrimary,
                                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                //     child: Padding(
                                //       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                //       child: Text(
                                //         'Most requested'.tr(),
                                //         style: const TextStyle(
                                //           fontSize: 12,
                                //           color: Colors.white,
                                //           fontWeight: FontWeight.w100,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            mostRequested[index].name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              mostRequested[index].stars.toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
