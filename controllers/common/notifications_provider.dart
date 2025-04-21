import 'package:ajeer/constants/domain.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:ajeer/main.dart';
import 'package:ajeer/models/customer/provider/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class NotificationsProvider with ChangeNotifier {
  final String? _accessToken; // comes from Auth() provider
  NotificationsProvider(this._accessToken);

  List<UserNotification> _notifications = [];

  List<UserNotification> get notifications => _notifications;

  Future<ResponseHandler<List<UserNotification>>> fetchNotifications() async {
    ResponseHandler<List<UserNotification>> handledResponse = ResponseHandler(status: ResponseStatus.error);

    String url = '${navigatorKey.currentContext!.read<Auth>().isProvider ? BaseURL.baseServiceProviderUrl : BaseURL.baseCustomerUrl}/notifications';
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
        _notifications = notificationListFromJson(response.body);
        notifyListeners();

        handledResponse.response = _notifications;
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(location: 'fetchNotifications STATUS CODE', message: response.statusCode);
      logMessage(location: 'fetchNotifications RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(location: 'ERROR ON fetchNotifications', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler> setFCMDeviceToken() async {
    ResponseHandler handledResponse = ResponseHandler(status: ResponseStatus.error);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    String url = '${navigatorKey.currentContext!.read<Auth>().isProvider ? BaseURL.baseServiceProviderUrl : BaseURL.baseCustomerUrl}/updatetoken';

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'authorization': 'Bearer $_accessToken',
          'content-type': 'application/x-www-form-urlencoded',
        },
        body: 'device_token=$fcmToken',
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(location: 'setFCMDeviceToken STATUS CODE', message: response.statusCode);
      logMessage(location: 'setFCMDeviceToken RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(location: 'ERROR ON setFCMDeviceToken', message: e.toString(), stack: s.toString());
    }
    return handledResponse;
  }
}
