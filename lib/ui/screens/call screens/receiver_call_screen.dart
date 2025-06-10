// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import '../../../services/call_service.dart';
//
// class ReceiverCallScreen extends StatefulWidget {
//   final String channelName;
//   final String callerImageUrl;
//   final String callerName;
//   final bool isRtl;
//
//   const ReceiverCallScreen({
//     Key? key,
//     required this.channelName,
//     required this.callerImageUrl,
//     required this.callerName,
//     required this.isRtl,
//   }) : super(key: key);
//
//   @override
//   State<ReceiverCallScreen> createState() => _ReceiverCallScreenState();
// }
//
// class _ReceiverCallScreenState extends State<ReceiverCallScreen> {
//   bool _isMuted = false;
//   bool _isSpeakerOn = true;
//   bool _isCallEnded = false;
//   bool _isRemoteUserOffline = false;
//   bool _isEndingCall = false;
//   bool _isLeavingChannel = false;
//   bool _canCloseScreen = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCall();
//   }
//
//   Future<void> _initializeCall() async {
//     try {
//       await CallService.initializeAgora();
//       await CallService.joinChannel(widget.channelName);
//
//       CallService.engine?.registerEventHandler(
//         RtcEngineEventHandler(
//           onUserOffline: (connection, remoteUid, reason) {
//             print("User offline: $remoteUid, reason: $reason");
//             if (!_isCallEnded && !_isEndingCall) {
//               setState(() {
//                 _isRemoteUserOffline = true;
//               });
//               _endCall(isRemoteUserOffline: true);
//             }
//           },
//           onError: (err, msg) {
//             print("Agora error: $err, $msg");
//             if (!_isCallEnded && !_isEndingCall) {
//               _endCall(isRemoteUserOffline: false);
//             }
//           },
//           onJoinChannelSuccess: (connection, elapsed) {
//             print("Successfully joined channel: ${widget.channelName}");
//           },
//           onUserJoined: (connection, remoteUid, elapsed) {
//             print("Remote user joined: $remoteUid");
//           },
//         ),
//       );
//     } catch (e) {
//       print("Error initializing call: $e");
//       if (!_isCallEnded && !_isEndingCall) {
//         _endCall(isRemoteUserOffline: false);
//       }
//     }
//   }
//
//   Future<void> _endCall({bool isRemoteUserOffline = false}) async {
//     if (_isEndingCall || _isLeavingChannel) return;
//
//     setState(() {
//       _isEndingCall = true;
//       _isCallEnded = true;
//     });
//
//     try {
//       if (!isRemoteUserOffline && !_isLeavingChannel) {
//         setState(() {
//           _isLeavingChannel = true;
//         });
//
//         // محاولة مغادرة القناة
//         await CallService.leaveChannel();
//
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('تم إنهاء المكالمة'),
//               duration: Duration(seconds: 3),
//             ),
//           );
//         }
//       }
//
//       // تأخير أطول قبل إغلاق الشاشة
//       await Future.delayed(Duration(seconds: 3));
//
//       setState(() {
//         _canCloseScreen = true;
//       });
//
//       if (mounted && _canCloseScreen) {
//         Navigator.of(context).pop();
//       }
//     } catch (e) {
//       print("Error ending call: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('حدث خطأ أثناء إنهاء المكالمة'),
//             duration: Duration(seconds: 3),
//           ),
//         );
//         // تأخير أطول في حالة الخطأ
//         await Future.delayed(Duration(seconds: 3));
//         setState(() {
//           _canCloseScreen = true;
//         });
//         if (mounted && _canCloseScreen) {
//           Navigator.of(context).pop();
//         }
//       }
//     } finally {
//       _isEndingCall = false;
//       _isLeavingChannel = false;
//     }
//   }
//
//   @override
//   void dispose() {
//     if (!_isRemoteUserOffline && !_isLeavingChannel) {
//       CallService.leaveChannel();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (!_isCallEnded) {
//           await _endCall(isRemoteUserOffline: false);
//           return false;
//         }
//         return _canCloseScreen;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Stack(
//           fit: StackFit.expand,
//           children: [
//             // Blurred background image
//             Image.network(
//               widget.callerImageUrl,
//               fit: BoxFit.cover,
//             ),
//             BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
//               child: Container(
//                 color: Colors.black.withOpacity(0.4),
//               ),
//             ),
//             // Content
//             SafeArea(
//               child: Column(
//                 children: [
//                   const SizedBox(height: 24),
//                   // Title
//                   Text(
//                     'مكالمة واردة',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 22,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     _isCallEnded
//                       ? (_isRemoteUserOffline ? 'انتهت المكالمة' : 'تم إنهاء المكالمة')
//                       : 'جاري الإتصال...',
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const Spacer(),
//                   // Profile image with badge
//                   Container(
//                     padding: EdgeInsets.all(0),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 8),
//                     ),
//                     child: CircleAvatar(
//                       radius: 60,
//                       backgroundImage: NetworkImage(widget.callerImageUrl),
//                     ),
//                   ),
//                   const SizedBox(height: 18),
//                   // Name
//                   Text(
//                     widget.callerName,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 20,
//                     ),
//                   ),
//                   const Spacer(),
//                   // Call controls
//                   if (!_isCallEnded) // إخفاء أزرار التحكم عند انتهاء المكالمة
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 32.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           // Speaker
//                           _CallControlButton(
//                             icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
//                             onTap: () async {
//                               setState(() {
//                                 _isSpeakerOn = !_isSpeakerOn;
//                               });
//                               await CallService.toggleSpeaker(_isSpeakerOn);
//                             },
//                           ),
//                           // End call (big red)
//                           _CallControlButton(
//                             icon: Icons.call_end,
//                             onTap: () => _endCall(isRemoteUserOffline: false),
//                             isMain: true,
//                           ),
//                           // Mute
//                           _CallControlButton(
//                             icon: _isMuted ? Icons.mic_off : Icons.mic,
//                             onTap: () async {
//                               setState(() {
//                                 _isMuted = !_isMuted;
//                               });
//                               await CallService.toggleMute(_isMuted);
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _CallControlButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   final bool isMain;
//
//   const _CallControlButton({
//     Key? key,
//     required this.icon,
//     required this.onTap,
//     this.isMain = false,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: isMain ? Colors.red[400] : Colors.white,
//       shape: CircleBorder(),
//       elevation: isMain ? 4 : 1,
//       child: InkWell(
//         customBorder: CircleBorder(),
//         onTap: onTap,
//         child: Container(
//           width: isMain ? 72 : 56,
//           height: isMain ? 72 : 56,
//           alignment: Alignment.center,
//           child: Icon(
//             icon,
//             color: isMain ? Colors.white : Colors.red[400],
//             size: isMain ? 36 : 28,
//           ),
//         ),
//       ),
//     );
//   }
// }
