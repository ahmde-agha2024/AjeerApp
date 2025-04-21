import 'package:flutter/material.dart';

class BackgroundProfileStack extends StatelessWidget {
  const BackgroundProfileStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Icons/back_profile.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        )
      ],
    );
  }
}
