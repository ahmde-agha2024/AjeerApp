import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ajeer/ui/screens/call screens/receiver_call_screen.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class FirebaseNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    String? token = await _firebaseMessaging.getToken();
    print("Device Token: $token");

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("New Token: $newToken");
    });

    await _setupLocalNotifications();

    // // Handle incoming messages when app is in foreground
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print("Received message in foreground:");
    //   print("Full message data: ${message.data}");
    //
    //   // Extract data from the response structure
    //   Map<String, dynamic> notificationData = message.data['data'] ?? {};
    //   print("Notification data: $notificationData");
    //
    //   String type = notificationData['type'] ?? '';
    //   String channelName = notificationData['channel_name'] ?? '';
    //   String callerName = notificationData['caller_name'] ?? '';
    //   String providerImage = notificationData['provider_image'] ?? '';
    //
    //   print("Extracted data:");
    //   print("Type: $type");
    //   print("Channel: $channelName");
    //   print("Caller: $callerName");
    //   print("Image: $providerImage");
    //
    //   if (type == 'customer' && channelName.isNotEmpty) {
    //     if (navigatorKey.currentContext != null) {
    //       showDialog(
    //         context: navigatorKey.currentContext!,
    //         barrierDismissible: false,
    //         builder: (context) => WillPopScope(
    //           onWillPop: () async => false,
    //           child: ReceiverCallScreen(
    //             channelName: channelName,
    //             callerImageUrl: providerImage,
    //             callerName: callerName,
    //             isRtl: true,
    //           ),
    //         ),
    //       );
    //     } else {
    //       print("Error: navigatorKey.currentContext is null");
    //     }
    //   }
    // });

    // // Handle notification tap when app is in background
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print("Notification tapped in background:");
    //   print("Full message data: ${message.data}");
    //
    //   // Extract data from the response structure
    //   Map<String, dynamic> notificationData = message.data['data'] ?? {};
    //   print("Notification data: $notificationData");
    //
    //   String type = notificationData['type'] ?? '';
    //   String channelName = notificationData['channel_name'] ?? '';
    //   String callerName = notificationData['caller_name'] ?? '';
    //   String providerImage = notificationData['provider_image'] ?? '';
    //
    //   print("Extracted data:");
    //   print("Type: $type");
    //   print("Channel: $channelName");
    //   print("Caller: $callerName");
    //   print("Image: $providerImage");
    //
    //   if (type == 'customer' && channelName.isNotEmpty) {
    //     if (navigatorKey.currentContext != null) {
    //       showDialog(
    //         context: navigatorKey.currentContext!,
    //         barrierDismissible: false,
    //         builder: (context) => WillPopScope(
    //           onWillPop: () async => false,
    //           child: ReceiverCallScreen(
    //             channelName: channelName,
    //             callerImageUrl: providerImage,
    //             callerName: callerName,
    //             isRtl: true,
    //           ),
    //         ),
    //       );
    //     } else {
    //       print("Error: navigatorKey.currentContext is null");
    //     }
    //   }
    // });
    //
    // // Handle initial message when app is opened from terminated state
    // RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    // if (initialMessage != null) {
    //   print("App opened from terminated state:");
    //   print("Full message data: ${initialMessage.data}");
    //
    //   // Extract data from the response structure
    //   Map<String, dynamic> notificationData = initialMessage.data['data'] ?? {};
    //   print("Notification data: $notificationData");
    //
    //   String type = notificationData['type'] ?? '';
    //   String channelName = notificationData['channel_name'] ?? '';
    //   String callerName = notificationData['caller_name'] ?? '';
    //   String providerImage = notificationData['provider_image'] ?? '';
    //
    //   print("Extracted data:");
    //   print("Type: $type");
    //   print("Channel: $channelName");
    //   print("Caller: $callerName");
    //   print("Image: $providerImage");
    //
    //   if (type == 'customer' && channelName.isNotEmpty) {
    //     if (navigatorKey.currentContext != null) {
    //       showDialog(
    //         context: navigatorKey.currentContext!,
    //         barrierDismissible: false,
    //         builder: (context) => WillPopScope(
    //           onWillPop: () async => false,
    //           child: ReceiverCallScreen(
    //             channelName: channelName,
    //             callerImageUrl: providerImage,
    //             callerName: callerName,
    //             isRtl: true,
    //           ),
    //         ),
    //       );
    //     } else {
    //       print("Error: navigatorKey.currentContext is null");
    //     }
    //   }
    // }
  }

  Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("User tapped on notification: ${response.payload}");
      },
    );
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.call,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? "New Notification",
      message.notification?.body ?? "",
      notificationDetails,
      payload: message.data.toString(),
    );
  }
}
