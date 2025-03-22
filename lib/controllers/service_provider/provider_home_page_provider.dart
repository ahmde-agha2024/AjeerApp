import 'package:ajeer/constants/domain.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/models/provider/home/provider_home_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProviderHomePageProvider with ChangeNotifier {
  final String? _accessToken; // comes from Auth() provider
  ProviderHomePageProvider(this._accessToken);

  ProviderHomePage? _providerHome;

  ProviderHomePage? get providerHome => _providerHome;

  Future<ResponseHandler<ProviderHomePage>> fetchProviderHomePage() async {
    ResponseHandler<ProviderHomePage> handledResponse = ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseServiceProviderUrl}/home';
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
        _providerHome = providerHomePageFromJson(response.body);

        handledResponse.response = _providerHome;
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(location: 'fetchProviderHomePage STATUS CODE', message: response.statusCode);
      logMessage(location: 'fetchProviderHomePage RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(location: 'ERROR ON fetchProviderHomePage', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }
}
