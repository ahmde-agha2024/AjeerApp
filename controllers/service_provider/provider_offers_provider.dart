import 'dart:convert';

import 'package:ajeer/constants/domain.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/models/provider/provider_offers_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ProviderOffersProvider with ChangeNotifier {
  final String? _accessToken; // comes from Auth() provider
  ProviderOffersProvider(this._accessToken);

  Future<ResponseHandler<ProviderOffers>> fetchMyOffers() async {
    ResponseHandler<ProviderOffers> handledResponse = ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseServiceProviderUrl}/offer';
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
        ProviderOffers providerOffers = providerOffersFromJson(response.body);

        handledResponse.response = providerOffers;
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(location: 'fetchMyOffers STATUS CODE', message: response.statusCode);
      logMessage(location: 'fetchMyOffers RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(location: 'ERROR ON fetchMyOffers', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler> createOfferForServiceRequest({required int serviceId, required double price, required String content, required String date, required DateTime time}) async {
    ResponseHandler handledResponse = ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseServiceProviderUrl}/offer';
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer $_accessToken',
        },
        body: 'service_id=$serviceId&price=$price&content=$content&date=$date&time=${(DateFormat('HH:mm').format(time))}',
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
      } else if (jsonDecode(response.body)['message'] != null) {
        handledResponse.status = ResponseStatus.error;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(location: 'createOfferForServiceRequest STATUS CODE', message: response.statusCode);
      logMessage(location: 'createOfferForServiceRequest RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(location: 'ERROR ON createOfferForServiceRequest', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler> cancelAnOffer(int offerId) async {
    ResponseHandler handledResponse = ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseServiceProviderUrl}/offer/$offerId';
    try {
      http.Response response = await http.delete(
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
      } else {
        handledResponse.status = ResponseStatus.error;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      }

      logMessage(location: 'cancelAnOffer STATUS CODE', message: response.statusCode);
      logMessage(location: 'cancelAnOffer RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(location: 'ERROR ON cancelAnOffer', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }
}
