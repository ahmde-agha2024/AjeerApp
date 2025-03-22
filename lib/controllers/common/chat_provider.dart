import 'dart:convert';

import 'package:ajeer/constants/domain.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:ajeer/main.dart';
import 'package:ajeer/models/common/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Chat with ChangeNotifier {
  final String? _accessToken; // comes from Auth() provider
  Chat(this._accessToken);

  Future<ResponseHandler<List<ChatHead>>> fetchChatHeads() async {
    ResponseHandler<List<ChatHead>> handledResponse = ResponseHandler(status: ResponseStatus.error);

    String url = '${navigatorKey.currentContext!.read<Auth>().isProvider ? BaseURL.baseServiceProviderUrl : BaseURL.baseCustomerUrl}/chat';
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
        handledResponse.response = chatHeadsFromJson(jsonDecode(response.body)['data']);
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(location: 'fetchChatHeads STATUS CODE', message: response.statusCode);
      logMessage(location: 'fetchChatHeads RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(location: 'ERROR ON fetchChatHeads', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<SingleChat>> fetchSingleChat({int? chatId, int? serviceId}) async {
    ResponseHandler<SingleChat> handledResponse = ResponseHandler(status: ResponseStatus.error);

    String url = '${navigatorKey.currentContext!.read<Auth>().isProvider ? BaseURL.baseServiceProviderUrl : BaseURL.baseCustomerUrl}${chatId != null ? '/chat/$chatId!' : '/chat/single/$serviceId!'}';
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
        handledResponse.response = singleChatFromJson(jsonDecode(response.body)['data']);
      } else if (response.statusCode == 404) {
        handledResponse.status = ResponseStatus.notFound;
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(location: 'fetchSingleChat STATUS CODE', message: response.statusCode);
      logMessage(location: 'fetchSingleChat RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(location: 'ERROR ON fetchSingleChat', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler> sendChatMessage({required int serviceId, required String message, String type = 'text'}) async {
    ResponseHandler<SingleChat> handledResponse = ResponseHandler(status: ResponseStatus.error);

    String url = '${navigatorKey.currentContext!.read<Auth>().isProvider ? BaseURL.baseServiceProviderUrl : BaseURL.baseCustomerUrl}/chat/send';
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'content-type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer $_accessToken',
        },
        body: 'service_id=$serviceId&message=$message&type=$type',
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(location: 'sendChatMessage RESPONSE', message: response.body.toString());
      logMessage(location: 'sendChatMessage STATUS CODE', message: response.statusCode);
    } catch (e, s) {
      logMessage(location: 'ERROR ON sendChatMessage', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }
}
