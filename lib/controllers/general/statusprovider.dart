import 'dart:convert'; // For encoding the body
import 'package:ajeer/constants/domain.dart';
import 'package:ajeer/constants/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart' show PusherChannelsFlutter;
PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
class StatusProviderController {
  static Future<bool> changeStatus(String serviceId, String status) async {
    String url = '${BaseURL.baseServiceProviderUrl}/change-status';
    //var providerId = storage.read("id_provider");
    final Map<String, dynamic> body = {
      'service_id': serviceId,
      'status': status,
    };
    var token = storage.read('token');
    // Send the POST request
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: json.encode(body), // Convert the body map into a JSON string
      );


      print(response.body);
      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
        return true;
      } else {
        // If the server returns an error
        //print('Failed to charge wallet. Status code: ${response.statusCode}');
        //print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle network errors
     // print('Error occurred: $e');
    }
    return false;
  }




}
