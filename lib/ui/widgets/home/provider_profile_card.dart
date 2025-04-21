import 'package:ajeer/models/customer/service_provider_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../constants/my_colors.dart';
import '../../../controllers/general/review_pass_provider.dart';
import '../../screens/provider_details_screen.dart';
import '../button_styles.dart';
import '../show_report_to_admin.dart';

class ProviderProfileCard extends StatelessWidget {
  ServiceProvider serviceProvider;

  ProviderProfileCard({super.key, required this.serviceProvider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProviderDetailsScreen(
                        providerId: serviceProvider.id,
                      )));
        },
        child: Card(
          elevation: 3,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16, right: 8),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: serviceProvider.image ??
                          'IMAGE', // TODO: ADD DEFAULT IMAGE
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                serviceProvider.name.tr(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: MyColors.Darkest,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          serviceProvider.category?.title ?? 'EMPTY'.tr(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                Text(
                                  serviceProvider.stars.toString() ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: MyColors.Darkest,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProviderDetailsScreen(
                                              providerId: serviceProvider.id,
                                            )));
                              },
                              style: flatButtonContinueStyle,
                              child: Text(
                                'View Profile'.tr(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
