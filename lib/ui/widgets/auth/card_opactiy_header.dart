import 'package:flutter/material.dart';

class CardOpacityHeader extends StatelessWidget {
  const CardOpacityHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.274),
                Opacity(
                  opacity: 0.25,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.284),
                Opacity(
                  opacity: 0.3,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
