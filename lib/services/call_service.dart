// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class AgoraService {
//   static const String appId = '31a6f9199ac648e4a906f0410509bde0';
//   late RtcEngine _engine;
//
//   Future<void> initAgora(String channelName) async {
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(
//       RtcEngineContext(
//         appId: appId,
//         channelProfile: ChannelProfileType.channelProfileCommunication,
//       ),
//     );
//
//     await _engine.enableAudio();
//
//     _engine.registerEventHandler(RtcEngineEventHandler(
//       onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//         print("Joined channel: $channelName");
//       },
//       onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//         print("User joined: $remoteUid");
//       },
//     ));
//
//     await _engine.joinChannel(
//       token:
//           "00631a6f9199ac648e4a906f0410509bde0IAAsZ49Eck71pfBdY7aCHVi5qQXoVI72zka8SL3vCa81MQx+f9i379yDEADzcwAAP+U9aAEAAQDPoTxo",
//       channelId: channelName,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }
//
//   void leaveChannel() {
//     _engine.leaveChannel();
//   }
// }
//
// class CallService {
//   static const String appId = "31a6f9199ac648e4a906f0410509bde0";
//   static RtcEngine? _engine;
//   static bool _isInitialized = false;
//   static const String baseUrl = "https://dev.ajeer.cloud";
//
//   static Future<void> initializeAgora() async {
//     if (!_isInitialized) {
//       _engine = createAgoraRtcEngine();
//       await _engine?.initialize(
//         RtcEngineContext(
//           appId: appId,
//           channelProfile: ChannelProfileType.channelProfileCommunication,
//         ),
//       );
//       await _engine?.enableAudio();
//       _isInitialized = true;
//     }
//   }
//
//   static Future<void> joinChannel(String channelName) async {
//     if (_engine == null) {
//       throw Exception('Agora engine not initialized');
//     }
//
//     await _engine?.joinChannel(
//       token: "00631a6f9199ac648e4a906f0410509bde0IAAsZ49Eck71pfBdY7aCHVi5qQXoVI72zka8SL3vCa81MQx+f9i379yDEADzcwAAP+U9aAEAAQDPoTxo",
//       channelId: channelName,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }
//
//   static Future<void> leaveChannel() async {
//     if (_engine != null) {
//       await _engine?.leaveChannel();
//       _engine = null;
//       _isInitialized = false;
//     }
//   }
//
//   static Future<void> toggleMute(bool isMuted) async {
//     if (_engine != null) {
//       await _engine?.muteLocalAudioStream(isMuted);
//     }
//   }
//
//   static Future<void> toggleSpeaker(bool isSpeakerOn) async {
//     if (_engine != null) {
//       await _engine?.setEnableSpeakerphone(isSpeakerOn);
//     }
//   }
//
//   static RtcEngine? get engine => _engine;
//
//   static Future<Map<String, dynamic>> initiateCall({
//     required String token,
//     required int providerId,
//     required int serviceId,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/customer/call/provider'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'provider_id': 915,
//           'service_id': "",
//         }),
//       );
//       print(response.body);
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data;
//       } else {
//         throw Exception('Failed to initiate call: ${response.body}');
//       }
//     } catch (e) {
//       print('Error initiating call: $e');
//       rethrow;
//     }
//   }
// }
