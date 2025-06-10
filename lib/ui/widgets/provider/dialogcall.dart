import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

void showCallBottomSheet(BuildContext context,String? phone) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon in circle
                    Center(
                      child: Image.asset(
                        'assets/Icons/callIcon.png',
                        // <-- Use your call+ icon asset here
                        width: 132,
                        height: 132,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Title
                    Text(
                      'هل ترغب في بدء المكالمة الآن؟',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xff232F3E),
                      ),
                    ),
                    const SizedBox(height: 22),
                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'يتم إجراء المكالمة لضمان وضوح الفهم بين العميل والمُقدِّم',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff7B7B7B),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Call Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            launchUrlString("tel://${phone}");
                            // Generate a unique channel name using provider ID and timestamp
                            // final channelName = "service_${DateTime.now().millisecondsSinceEpoch}";

                            //
                            // final channelName = "122";
                            //
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => VoiceCallScreen(
                            //             userName: "serviceProviderDetails!.response!.name!",
                            //             channelName: channelName,
                            //             userImageUrl: "https://images.pexels.com/photos/1707828/pexels-photo-1707828.jpeg")));


                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color(0xFFE04836),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'بدء المكالمة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Close button
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(Icons.close, color: Color(0xff7B7B7B)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}