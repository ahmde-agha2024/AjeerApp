import 'package:flutter/material.dart';

class AppbarBackonlyTransparent extends StatelessWidget {
  const AppbarBackonlyTransparent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
      ],
    );
  }
}
