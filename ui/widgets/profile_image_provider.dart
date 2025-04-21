import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileImageProvider extends StatelessWidget {
  final String profileImageUrl;
  bool isActive;
  ProfileImageProvider({super.key, required this.profileImageUrl, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.22,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16, right: 8),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(32)),
                        child: CachedNetworkImage(
                          imageUrl: profileImageUrl,
                          height: MediaQuery.of(context).size.height * 0.2,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                height: 28,
                width: 28,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
