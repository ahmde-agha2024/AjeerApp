import 'dart:developer';

import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:ajeer/main.dart';
import 'package:ajeer/ui/screens/auth/auth_screen.dart';
import 'package:ajeer/ui/screens/auth/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

logMessage({location, message, stack}) {
  if (kDebugMode) {
    log('---------------- $location --------------------\n'
        '$message${stack != null ? '\n$stack' : ''}\n'
        '\n--------------------------------------------------------');
  }
}

enum ResponseStatus {
  success,
  failure,
  notFound,
  error,
  duplicate,
}

class ResponseHandler<responseType> {
  ResponseStatus status = ResponseStatus.error;
  String? errorMessage;
  responseType? response;

  ResponseHandler({required this.status, this.response, this.errorMessage});
}

Future<bool> checkResponseHttp(http.Response response) async {
  if (response.statusCode == 401) {
    await Provider.of<Auth>(navigatorKey.currentContext!, listen: false).logout();
    navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthScreen()), (route) => false);
    return false;
  }
  return true;
}
