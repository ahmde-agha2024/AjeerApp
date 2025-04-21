import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../constants/my_colors.dart';

class PhotoZoomScreen extends StatelessWidget {
  String userName;
  String imagePath;
  PhotoZoomScreen({
    super.key,
    required this.imagePath,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            userName,
            style: TextStyle(
              color: MyColors.MainBulma,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: MyColors.MainBulma,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: PhotoView(
        backgroundDecoration: BoxDecoration(
          color: Colors.white,
        ),
        imageProvider: CachedNetworkImageProvider(
          imagePath,
        ),
      ),
    );
  }
}
