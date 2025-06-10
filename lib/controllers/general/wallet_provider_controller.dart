import 'dart:convert'; // For encoding the body
import 'package:ajeer/constants/domain.dart';
import 'package:ajeer/constants/get_storage.dart';
import 'package:http/http.dart' as http;

class WalletController {
  static Future<bool> chargeWallet(String coupon) async {
    String url = '${BaseURL.baseServiceProviderUrl}/charge-wallet';
    var providerId = storage.read("id_provider");
    final Map<String, dynamic> body = {
      'coupon': coupon,
      'provider_id': providerId,
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

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
        return true;
      } else {
        // If the server returns an error
        print('Failed to charge wallet. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle network errors
      print('Error occurred: $e');
    }
    return false;
  }

  static Future<bool> chargeCopunForDiscount(String coupon) async {
    String url = '${BaseURL.baseServiceProviderUrl}/new-packages/apply-coupon';
    var providerId = storage.read("id_provider");
    final Map<String, dynamic> body = {
      'coupon': coupon,
      'provider_id': providerId,
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
print(response.statusCode);
      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
        return true;
      } else {
        // If the server returns an error
        print('Failed to charge wallet. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle network errors
      print('Error occurred: $e');
    }
    return false;
  }


  static Future<bool> BuyWithWallet({required int packageId}) async {
    String url = '${BaseURL.baseServiceProviderUrl}/new-packages/subscribe';
    var providerId = storage.read("id_provider");
    final Map<String, dynamic> body = {
      'package_id': packageId,
      'provider_id': providerId,
    };
    var token = storage.read('token');
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

      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
        return true;
      } else {
        // If the server returns an error
        print('Failed to charge wallet. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle network errors
      print('Error occurred: $e');
    }
    return false;
  }

  Future<double> getWallet() async {
    final url = Uri.parse('${BaseURL.baseServiceProviderUrl}/get-wallet');
    var token = storage.read('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print('Request successful');
        var data = json.decode(response.body);
        return data;
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return 0.0;
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return 0.0;
  }

  Future<int> getstatus() async {
    final url = Uri.parse('${BaseURL.baseServiceProviderUrl}/is-true');
    var token = storage.read('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print('Request successful');
        print(response.body);
        var data = json.decode(response.body);
        return data;
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return 1;
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return 0;
  }
}
