import 'dart:convert';

import 'package:ajeer/constants/domain.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:ajeer/models/common/category_model.dart';
import 'package:ajeer/models/customer/home/home_model.dart';
import 'package:ajeer/models/customer/service_provider_details_model.dart';
import 'package:ajeer/models/customer/service_provider_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomerHomeProvider with ChangeNotifier {
  final String? _accessToken; // comes from Auth() provider
  CustomerHomeProvider(this._accessToken);

  CustomerHome? _customerHome;

  CustomerHome? get customerHome => _customerHome;

  Future<ResponseHandler<CustomerHome>> fetchCustomerHomePage() async {
    ResponseHandler<CustomerHome> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/home';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'authorization': 'Bearer $_accessToken',
        },
      );
print(response.body);
      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }
      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        _customerHome = customerHomeFromJson(response.body);

        // update auth provider with user data
        await Auth().setCustomerUserInfo(_customerHome!.user);
        handledResponse.response = _customerHome;
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'fetchCustomerHomePage STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'fetchCustomerHomePage RESPONSE',
          message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON fetchCustomerHomePage',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<List<Category>>> fetchCategories() async {
    ResponseHandler<List<Category>> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/categories';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'authorization': 'Bearer $_accessToken',
        },
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        handledResponse.response =
            categoryListFromJson(jsonDecode(response.body)['data']);
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'fetchCategories STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'fetchCategories RESPONSE',
          message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON fetchCategories',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<Category>> fetchSingleCategory(
      {required int categoryId}) async {
    ResponseHandler<Category> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/category/$categoryId';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'authorization': 'Bearer $_accessToken',
        },
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        handledResponse.response =
            Category.fromJson(jsonDecode(response.body)['data']);
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'fetchSingleCategory STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'fetchSingleCategory RESPONSE', message: response.body);
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON fetchSingleCategory',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<List<ServiceProvider>>> searchProviders(
      String query) async {
    ResponseHandler<List<ServiceProvider>> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    if (query.length < 2) {
      return handledResponse;
    }

    String url = '${BaseURL.baseCustomerUrl}/providers/search?search=$query';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'authorization': 'Bearer $_accessToken',
        },
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        handledResponse.response =
            serviceProviderFromJson(jsonDecode(response.body)['data']);
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'searchProviders STATUS CODE',
          message: response.statusCode);
      logMessage(location: 'searchProviders RESPONSE', message: response.body);
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON searchProviders',
          message: e.toString(),
          stack: s.toString());
    }

    return handledResponse;
  }

  Future<ResponseHandler<List<ServiceProvider>>> fetchSubCategoryProviders(
      {required int categoryId}) async {
    ResponseHandler<List<ServiceProvider>> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/subcategory/$categoryId/providers';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'authorization': 'Bearer $_accessToken',
        },
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        handledResponse.response =
            serviceProviderFromJson(jsonDecode(response.body)['data']);
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'fetchSubCategoryProviders STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'fetchSubCategoryProviders RESPONSE',
          message: response.body);
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON fetchSubCategoryProviders',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<List<ServiceProvider>>>
      fetchFavoriteServiceProviders() async {
    ResponseHandler<List<ServiceProvider>> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/favourite';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'authorization': 'Bearer $_accessToken',
        },
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        handledResponse.response =
            favoriteProvidersFromJson(jsonDecode(response.body)['data']);
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'fetchFavoriteServiceProviders STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'fetchFavoriteServiceProviders RESPONSE',
          message: response.body);
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON fetchFavoriteServiceProviders',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<ServiceProviderDetails>> fetchServiceProviderDetails(
      {required int providerId}) async {
    ResponseHandler<ServiceProviderDetails> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/provider/$providerId';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'authorization': 'Bearer $_accessToken',
        },
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        handledResponse.response =
            ServiceProviderDetails.fromJson(jsonDecode(response.body)['data']);
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'fetchServiceProviderDetails STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'fetchServiceProviderDetails RESPONSE',
          message: response.body);
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON fetchServiceProviderDetails',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<List<ServiceProvider>>> fetchAllServiceProviders({
      required int pageNumber,
      required int pageSize,}
  ) async {
    ResponseHandler<List<ServiceProvider>> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    print(pageNumber);
    String url = '${BaseURL.baseCustomerUrl}/providers?page_number=$pageNumber&page_size=$pageSize';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'authorization': 'Bearer $_accessToken',
        },
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        handledResponse.response =
            serviceProviderFromJson(jsonDecode(response.body)['data']);
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'fetchAllServiceProviders STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'fetchAllServiceProviders RESPONSE',
          message: response.body);
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON fetchAllServiceProviders',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<List<ServiceProvider>>> fetchAllTopSelling({
    required int pageNumber,
    required int pageSize,
  }) async {
    ResponseHandler<List<ServiceProvider>> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/top_selling?page_number=$pageNumber&page_size=$pageSize';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'authorization': 'Bearer $_accessToken',
        },
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        handledResponse.response =
            serviceProviderFromJson(jsonDecode(response.body)['data']);
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'fetchAllTopSelling STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'fetchAllTopSelling RESPONSE',
          message: response.body);
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON fetchAllTopSelling',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  // Future<Map<String, dynamic>> fetchSubscriptionStatus() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('https://dev.ajeer.cloud/provider/new-packages-my-subscriptions'),
  //       headers: {
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/json',
  //         // Add your authorization header if needed
  //         'authorization': 'Bearer $_accessToken',
  //       },
  //     );
  //
  //     print(_accessToken);
  //     print(response.statusCode);
  //
  //     if (response.statusCode == 200) {
  //       return json.decode(response.body);
  //     } else {
  //       throw Exception('Failed to load subscription status');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching subscription status: $e');
  //   }
  // }
}


