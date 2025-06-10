// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:ajeer/ui/screens/call screens/receiver_call_screen.dart';
//
// import '../main.dart';
//
// class CallNotificationService {
//   static void handleCallNotification(RemoteMessage message) {
//     final data = message.data;
//
//     if (data['type'] == 'customer') {
//       // Get the current context
//       final context = navigatorKey.currentContext;
//       if (context != null) {
//         // Show the receiver call screen
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ReceiverCallScreen(
//               isRtl: true,
//               callerName: data['caller_name'] ?? 'Unknown',
//               callerImageUrl: data['customer_image'] ?? 'https://via.placeholder.com/150',
//               channelName: data['channel_name'] ?? '',
//             ),
//           ),
//         );
//       }
//     }
//   }
//
//   static Future<void> sendCallNotification({
//     required String deviceToken,
//     required String type, // 'customer' or 'provider'
//     required String callerName,
//     required String callerImageUrl,
//     required String channelName,
//   }) async {
//     try {
//       // Here you would typically make an API call to your backend
//       // to send the FCM notification. For example:
//
//       // final response = await http.post(
//       //   Uri.parse('https://your-api.com/send-notification'),
//       //   headers: {
//       //     'Content-Type': 'application/json',
//       //     'Authorization': 'Bearer YOUR_API_KEY',
//       //   },
//       //   body: jsonEncode({
//       //     'type': type,
//       //     'to': deviceToken,
//       //     'data': {
//       //       'type': 'call',
//       //       'callerName': callerName,
//       //       'callerImageUrl': callerImageUrl,
//       //       'channelName': channelName,
//       //     },
//       //   }),
//       // );
//
//       // For now, we'll just print the notification details
//       print('Sending call notification to: $deviceToken');
//       print('Caller: $callerName');
//       print('Channel: $channelName');
//     } catch (e) {
//       print('Error sending call notification: $e');
//     }
//   }
// }