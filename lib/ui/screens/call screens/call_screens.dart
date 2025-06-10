// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import '../../../services/call_service.dart';
//
// class VoiceCallScreen extends StatefulWidget {
//   final String userName;
//   final String userImageUrl;
//   final bool isRtl;
//   final String channelName;
//
//   const VoiceCallScreen({
//     Key? key,
//     required this.userName,
//     required this.userImageUrl,
//     required this.channelName,
//     this.isRtl = true,
//   }) : super(key: key);
//
//   @override
//   State<VoiceCallScreen> createState() => _VoiceCallScreenState();
// }
//
// class _VoiceCallScreenState extends State<VoiceCallScreen> {
//   bool _isMuted = false;
//   bool _isSpeakerOn = true;
//   bool _isCallEnded = false;
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
//             if (!_isCallEnded) {
//               _endCall();
//             }
//           },
//           onError: (err, msg) {
//             print("Agora error: $err, $msg");
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
//       _endCall();
//     }
//   }
//
//   Future<void> _endCall() async {
//     if (!_isCallEnded) {
//       setState(() {
//         _isCallEnded = true;
//       });
//
//       try {
//         await CallService.leaveChannel();
//         if (mounted) {
//           Navigator.of(context).pop();
//         }
//       } catch (e) {
//         print("Error ending call: $e");
//         if (mounted) {
//           Navigator.of(context).pop();
//         }
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     CallService.leaveChannel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Directionality(
//         textDirection: widget.isRtl ? TextDirection.rtl : TextDirection.ltr,
//         child: Scaffold(
//           backgroundColor: Colors.black,
//           body: Stack(
//             fit: StackFit.expand,
//             children: [
//               // Blurred background image
//               Image.network(
//                 widget.userImageUrl,
//                 fit: BoxFit.cover,
//               ),
//               BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
//                 child: Container(
//                   color: Colors.black.withOpacity(0.4),
//                 ),
//               ),
//               // Content
//               SafeArea(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 24),
//                     // Title
//                     Text(
//                       'مكالمة صوتية',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 22,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       _isCallEnded ? 'تم إنهاء المكالمة' : 'جاري الإتصال...',
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const Spacer(),
//                     // Profile image with badge
//                     Container(
//                       padding: EdgeInsets.all(0),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 8),
//                       ),
//                       child: CircleAvatar(
//                         radius: 60,
//                         backgroundImage: NetworkImage(widget.userImageUrl),
//                       ),
//                     ),
//                     const SizedBox(height: 18),
//                     // Name
//                     Text(
//                       widget.userName,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 20,
//                       ),
//                     ),
//                     const Spacer(),
//                     // Call controls
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
//                             onTap: _endCall,
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
//                   ],
//                 ),
//               ),
//             ],
//           ),
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
