import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class ReviewPass with ChangeNotifier {
  bool _isAppleReview = false;
  bool get isAppleReview => _isAppleReview;

  ReviewPass() {
    fetchReviewStatus();
  }

  Future<void> fetchReviewStatus() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 20),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      await remoteConfig.fetchAndActivate();

      _isAppleReview = remoteConfig.getBool('is_apple_review');
      print('isAppleReview: $_isAppleReview');
      notifyListeners();
    } catch (e) {
      print("Error fetching remote config: $e");
    }
  }
}
