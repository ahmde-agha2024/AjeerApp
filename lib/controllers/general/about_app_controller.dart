import 'dart:convert';

import 'package:ajeer/constants/domain.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:ajeer/main.dart';
import 'package:ajeer/models/general/about_app_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AboutApp with ChangeNotifier {
  Future<ResponseHandler<AboutAppModel>> fetchAboutApp() async {
    ResponseHandler<AboutAppModel> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/setting';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        handledResponse.response =
            aboutAppFromJson(jsonDecode(response.body)['data']);
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'fetchAboutApp STATUS CODE', message: response.statusCode);
      logMessage(
          location: 'fetchAboutApp RESPONSE',
          message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON fetchAboutApp',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<String>> fetchTermsAndConditions() async {
    ResponseHandler<String> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url =
        '${navigatorKey.currentContext!.read<Auth>().isProvider ? BaseURL.baseServiceProviderUrl : BaseURL.baseCustomerUrl}/terms';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        handledResponse.response = jsonDecode(response.body)['data']['content'];
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'fetchTermsAndConditions STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'fetchTermsAndConditions RESPONSE',
          message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON fetchTermsAndConditions',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<List<Faq>>> fetchFaq() async {
    ResponseHandler<List<Faq>> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/faq';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        handledResponse.response =
            faqFromJson(jsonDecode(response.body)['faq']);
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'fetchFaq STATUS CODE', message: response.statusCode);
      logMessage(
          location: 'fetchFaq RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON fetchFaq',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler> contactUs(String title, String message) async {
    ResponseHandler handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url =
        '${navigatorKey.currentContext!.read<Auth>().isProvider ? BaseURL.baseServiceProviderUrl : BaseURL.baseCustomerUrl}/contact';
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${navigatorKey.currentContext!.read<Auth>().accessToken}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'title=$title&message=$message',
      );
      logMessage(
          location: 'contactUs RESPONSE', message: response.body.toString());

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'contactUs STATUS CODE', message: response.statusCode);
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON contactUs',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }
}
