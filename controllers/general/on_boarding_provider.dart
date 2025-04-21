import 'dart:convert';

import 'package:ajeer/constants/domain.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/models/common/category_model.dart';
import 'package:ajeer/models/common/region_model.dart';
import 'package:ajeer/models/customer/provider/service_provider_account.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/general/onboarding_model.dart';

class OnBoardingProvider with ChangeNotifier {
  List<OnBoardingModel> _onBoardings = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<OnBoardingModel> get onBoardings => _onBoardings;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setOnBoardings(List<OnBoardingModel> onBoardings) {
    _onBoardings = onBoardings;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchOnBoardings() async {
    setLoading(true);

    var dio = Dio();

    try {
      var response = await dio.request(
        '${BaseURL.baseCustomerUrl}/onboarding',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<OnBoardingModel> loadedOnBoardings = [];
        var data = response.data['data'];
        for (var onBoardingJson in data) {
          var onBoarding = OnBoardingModel.fromJson(onBoardingJson);
          loadedOnBoardings.add(onBoarding);
        }
        setOnBoardings(loadedOnBoardings);
      } else {
        setErrorMessage(response.statusMessage);
      }
    } catch (e) {
      setErrorMessage("An error occurred");
    } finally {
      setLoading(false);
    }
  }

  Future<ResponseHandler<List<Category>>> fetchProviderCategories() async {
    ResponseHandler<List<Category>> handledResponse = ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseServiceProviderUrl}/categories';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        notifyListeners();

        handledResponse.response = categoryListFromJson(jsonDecode(response.body)['data']);
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(location: 'fetchProviderCategories STATUS CODE', message: response.statusCode);
      logMessage(location: 'fetchProviderCategories RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(location: 'ERROR ON fetchProviderCategories', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<List<Category>>> fetchProviderSubCategories(int categoryId) async {
    ResponseHandler<List<Category>> handledResponse = ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseServiceProviderUrl}/category/$categoryId';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        notifyListeners();

        handledResponse.response = categoryListFromJson(jsonDecode(response.body)['data']['sub_categories']);
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(location: 'fetchProviderSubCategories STATUS CODE', message: response.statusCode);
      logMessage(location: 'fetchProviderSubCategories RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(location: 'ERROR ON fetchProviderSubCategories', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<List<City>>> fetchProviderCities() async {
    ResponseHandler<List<City>> handledResponse = ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseServiceProviderUrl}/cities';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;

        handledResponse.response = citiesFromJson(jsonDecode(response.body)['cities']);
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(location: 'fetchProviderCities STATUS CODE', message: response.statusCode);
      logMessage(location: 'fetchProviderCities RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(location: 'ERROR ON fetchProviderCities', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<List<Region>>> fetchCityRegions({required int cityId}) async {
    ResponseHandler<List<Region>> handledResponse = ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseServiceProviderUrl}/regions/$cityId';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
      );

      logMessage(location: 'fetchCityRegions STATUS CODE', message: response.statusCode);
      logMessage(location: 'fetchCityRegions RESPONSE', message: response.body.toString());

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;

        handledResponse.response = regionsFromJson(jsonDecode(response.body)['regions']);
      } else {
        handledResponse.status = ResponseStatus.error;
      }
    } catch (e, s) {
      logMessage(location: 'ERROR ON fetchCityRegions', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }
}
