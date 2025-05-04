import 'package:ajeer/constants/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:ui';

class ForceUpdateService {
  static const String _versionCheckUrl = 'https://dev.ajeer.cloud/version';
  static const String _appStoreUrl = 'https://apps.apple.com/ly/app/ajeer/id6736632788';
  static const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=com.ajeer.ajeer';

  static Future<bool> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      
      final response = await http.get(Uri.parse(_versionCheckUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final minVersion = data['min_version'];
        
        return _compareVersions(currentVersion, minVersion) < 0;
      }
      return false;
    } catch (e) {
      print('Error checking for updates: $e');
      return false;
    }
  }

  static int _compareVersions(String version1, String version2) {
    final v1 = version1.split('.').map(int.parse).toList();
    final v2 = version2.split('.').map(int.parse).toList();
    
    for (var i = 0; i < v1.length; i++) {
      if (i >= v2.length) return 1;
      if (v1[i] > v2[i]) return 1;
      if (v1[i] < v2[i]) return -1;
    }
    return 0;
  }

  static void showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: WillPopScope(
            onWillPop: () async => false,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Dialog(
                backgroundColor: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/Icons/downloads.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        ' يتوفر إصدار جديد الآن',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B1C17),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'يجب تحديث التطبيق لمواصلة الاستخدام',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff636363),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            _launchStore();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.MainBulma,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'تحديث الآن',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
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
    );
  }

  static Future<void> _launchStore() async {
    final url = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
    }
  }
} 