import 'dart:convert';

import 'package:ajeer/constants/domain.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/models/customer/service_model.dart';
import 'package:ajeer/models/provider/provider_services_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProviderServicesProvider with ChangeNotifier {
  final String? _accessToken; // comes from Auth() provider
  ProviderServicesProvider(this._accessToken);

  Future<ResponseHandler<List<Service>>> getAllNewServices() async {
    ResponseHandler<List<Service>> handledResponse = ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseServiceProviderUrl}/newservices';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer $_accessToken',
        },
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        handledResponse.response = servicesListFromJson(jsonDecode(response.body)['data']);
      } else if (jsonDecode(response.body)['message'] != null) {
        handledResponse.status = ResponseStatus.error;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(location: 'getAllNewServices STATUS CODE', message: response.statusCode);
      logMessage(location: 'getAllNewServices RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(location: 'ERROR ON getAllNewServices', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<ProviderServices>> getMyServices() async {
    ResponseHandler<ProviderServices> handledResponse = ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseServiceProviderUrl}/service';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer $_accessToken',
        },
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        handledResponse.response = providerServicesFromJson(response.body);
      } else if (jsonDecode(response.body)['message'] != null) {
        handledResponse.status = ResponseStatus.error;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(location: 'getMyServices STATUS CODE', message: response.statusCode);
      logMessage(location: 'getMyServices RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(location: 'ERROR ON getMyServices', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler> cancelAService(int serviceId, String cancellationReason) async {
    ResponseHandler handledResponse = ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseServiceProviderUrl}/servicecancel';
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer $_accessToken',
        },
        body: 'service_id=$serviceId&cancellation_reason=$cancellationReason',
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
      } else {
        handledResponse.status = ResponseStatus.error;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      }

      logMessage(location: 'cancelAService STATUS CODE', message: response.statusCode);
      logMessage(location: 'cancelAService RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(location: 'ERROR ON cancelAService', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }

   Future<ResponseHandler> changeStatus(String serviceId, String status) async {
    ResponseHandler handledResponse = ResponseHandler(status: ResponseStatus.success);

    String url = '${BaseURL.baseServiceProviderUrl}/change-status';
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer $_accessToken',
        },
        body: 'service_id=$serviceId&status=$status',
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
      } else {
        handledResponse.status = ResponseStatus.error;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      }

   //   logMessage(location: 'cancelAService STATUS CODE', message: response.statusCode);
     // logMessage(location: 'cancelAService RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(location: 'ERROR ON cancelAService', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }
}
