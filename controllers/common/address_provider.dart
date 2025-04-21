import 'dart:convert';

import 'package:ajeer/models/auth/address_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/domain.dart';

class AddressProvider with ChangeNotifier {
  final String? _accessToken;
  AddressProvider(this._accessToken);

  List<Address> _addresses = [];
  bool _isDataLoaded = false;

  List<Address> get addresses => _addresses;
  bool get isDataLoaded => _isDataLoaded;

  Future<void> fetchAddresses() async {
    String url = '${BaseURL.baseCustomerUrl}/address';
    try {
      _isDataLoaded = false;
      notifyListeners();

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        _addresses = addressFromJson(json.decode(response.body)['data']);
      } else {
        _addresses = [];
        print('Error fetching addresses: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
      _addresses = [];
    } finally {
      _isDataLoaded = true;
      notifyListeners();
    }
  }

  Future<bool> addAddress({
    required String title,
    required String address,
    required String lat,
    required String lng,
    required String cityId,
    required String regionId,
  }) async {
    final url = '${BaseURL.baseCustomerUrl}/address';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $_accessToken',
        },
        body: {
          'title': title,
          'address': address,
          'lat': lat,
          'lng': lng,
          'city_id': cityId,
          'region_id': regionId,
        },
      );

      if (response.statusCode == 200) {
        await fetchAddresses();
        return true;
      } else {
        print('Failed to add address: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> updateAddress({
    required int id,
    required String title,
    required String address,
    required String lat,
    required String lng,
    required String cityId,
    required String regionId,
  }) async {
    final url = '${BaseURL.baseCustomerUrl}/address/$id';
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $_accessToken',
        },
        body: {
          'title': title,
          'address': address,
          'lat': lat,
          'lng': lng,
          'city_id': cityId,
          'region_id': regionId,
        },
      );

      if (response.statusCode == 200) {
        await fetchAddresses();
        return true;
      } else {
        print('Failed to update address: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<void> deleteAddress(int id) async {
    final url = '${BaseURL.baseCustomerUrl}/address/$id';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        await fetchAddresses();
      } else {
        print('Failed to delete address: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
