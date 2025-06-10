import 'dart:convert';

import 'package:ajeer/constants/domain.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/models/provider/provider_subscriptions_model.dart';
import 'package:ajeer/models/customer/subscription_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProviderSubscriptions with ChangeNotifier {
  final String? _accessToken; // comes from Auth() provider
  ProviderSubscriptions(this._accessToken);

  Future<ResponseHandler<List<ProviderSubscriptionPackage>>>
      fetchAvailablePackages() async {
    ResponseHandler<List<ProviderSubscriptionPackage>> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseServiceProviderUrl}/packages';
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
        List<ProviderSubscriptionPackage> providerSubscriptions =
            providerSubscriptionPackagesFromJson(
                jsonDecode(response.body)['packages']);

        handledResponse.response = providerSubscriptions;
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'fetchAvailableSubscriptions STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'fetchAvailableSubscriptions RESPONSE',
          message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON fetchAvailableSubscriptions',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<String>> subscribeToAPackage(
      {required int packageId}) async {
    ResponseHandler<String> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseServiceProviderUrl}/new-packages-subscribe';
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'authorization': 'Bearer $_accessToken',
          'content-type': 'application/x-www-form-urlencoded',
        },
        body: 'package_id=$packageId',
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }
      print(response.body);
      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        handledResponse.response = jsonDecode(response.body)['url'];
      } else if (jsonDecode(response.body)['message'] != null) {
        handledResponse.status = ResponseStatus.error;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'subscribeToAPackage STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'subscribeToAPackage RESPONSE',
          message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON subscribeToAPackage',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<String>> subscribetylink(
      {required int packageId}) async {
    ResponseHandler<String> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url =
        '${BaseURL.baseServiceProviderUrl}/new-packages-subscribe-payment';
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'authorization': 'Bearer $_accessToken',
          'content-type': 'application/x-www-form-urlencoded',
        },
        body: 'package_id=$packageId',
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        handledResponse.response = jsonDecode(response.body)['url'];
      } else if (jsonDecode(response.body)['message'] != null) {
        handledResponse.status = ResponseStatus.error;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'subscribeToAPackage STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'subscribeToAPackage RESPONSE',
          message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON subscribeToAPackage',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<SubscriptionResponse>> fetchMySubscriptions() async {
    ResponseHandler<SubscriptionResponse> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url =
        'https://dev.ajeer.cloud/provider/new-packages-my-subscriptions';
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
      print("response.body");
      print(response.body);
      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        handledResponse.response =
            SubscriptionResponse.fromJson(jsonDecode(response.body));
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'fetchMySubscriptions STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'fetchMySubscriptions RESPONSE',
          message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON fetchMySubscriptions',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

// Future<ResponseHandler<AboutAppModel>> fetchAboutApp() async {
//   ResponseHandler<AboutAppModel> handledResponse =
//   ResponseHandler(status: ResponseStatus.error);
//
//   String url = '${BaseURL.baseCustomerUrl}/setting';
//   try {
//     http.Response response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Accept': 'application/json',
//       },
//     );
//
//     if (!await checkResponseHttp(response)) {
//       return handledResponse;
//     }
//
//     if (response.statusCode == 200) {
//       handledResponse.status = ResponseStatus.success;
//       handledResponse.response =
//           aboutAppFromJson(jsonDecode(response.body)['data']);
//     } else {
//       handledResponse.status = ResponseStatus.error;
//     }
//
//     logMessage(
//         location: 'fetchAboutApp STATUS CODE', message: response.statusCode);
//     logMessage(
//         location: 'fetchAboutApp RESPONSE',
//         message: response.body.toString());
//   } catch (e, s) {
//     logMessage(
//         location: 'ERROR ON fetchAboutApp',
//         message: e.toString(),
//         stack: s.toString());
//   }
//   return handledResponse;
// }
}
