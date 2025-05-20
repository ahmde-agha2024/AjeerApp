import 'dart:convert';
import 'dart:io';

import 'package:ajeer/constants/domain.dart';
import 'package:ajeer/constants/get_storage.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/common/notifications_provider.dart';
import 'package:ajeer/models/auth/customer/user_model.dart';
import 'package:ajeer/models/customer/provider/service_provider_account.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Auth with ChangeNotifier {
  bool _isAuth = false;
  String? _accessToken;
  String? _errorMessage;
  bool _isClient = true;
  bool _isProvider = false;
  bool isLoginScreen = true;
  Customer? _customer;
  ServiceProviderAccount? _provider;

  String? get errorMessage => _errorMessage;

  String? get accessToken => _accessToken;

  bool get isClient => _isClient;

  Customer? get customer => _customer;

  ServiceProviderAccount? get provider => _provider;

  bool get isProvider => _isProvider;

  bool get isAuth => _isAuth;

  Future<bool> checkAuth() async {
    await storage.read('token') != null ? _isAuth = true : _isAuth = false;
    notifyListeners();
    return _isAuth;
  }

  Future<ResponseHandler> signUpAsCustomer(
      {required String fullName,
      required String phoneNumber,
      required String password,
      required String passwordConfirmation,
      required String invite_link}) async {
    ResponseHandler handledResponse =
        ResponseHandler(status: ResponseStatus.error);
    String url = '${BaseURL.baseCustomerUrl}/register';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body:
            'name=$fullName&phone=$phoneNumber&password=$password&password_confirmation=$passwordConfirmation&invite_token=$invite_link',
      );
      print(
          'name=$fullName&phone=$phoneNumber&password=$password&password_confirmation=$passwordConfirmation');

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
      } else if (response.statusCode == 422 &&
          jsonDecode(response.body)['message'] ==
              "قيمة الهاتف مُستخدمة من قبل") {
        handledResponse.status = ResponseStatus.duplicate;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      } else {
        handledResponse.status = ResponseStatus.error;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      }

      logMessage(
          location: 'REGISTER RESPONSE STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'REGISTER RESPONSE', message: response.body.toString());
    } catch (e) {
      logMessage(location: 'ERROR ON REGISTER', message: e.toString());
      handledResponse.status = ResponseStatus.error;
    }

    return handledResponse;

    // changeIsLoading(false);
  }

  Future<ResponseHandler> sendOTP({required String phoneNumber}) async {
    ResponseHandler handledResponse =
        ResponseHandler(status: ResponseStatus.error);
    String url =
        '${_isProvider && !isClient ? BaseURL.baseServiceProviderUrl : BaseURL.baseCustomerUrl}/otp';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'phone=$phoneNumber',
      );
print(response.statusCode);
      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
      } else if (response.statusCode == 422 &&
          jsonDecode(response.body)['message'] != null) {
        handledResponse.status = ResponseStatus.failure;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      } else {
        handledResponse.status = ResponseStatus.notFound;
      }

      logMessage(
          location: 'customerSendOTP RESPONSE STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'customerSendOTP RESPONSE',
          message: response.body.toString());
    } catch (e) {
      logMessage(location: 'ERROR ON customerSendOTP', message: e.toString());
      handledResponse.status = ResponseStatus.error;
    }

    return handledResponse;
  }

  Future<ResponseHandler> sendOTPNew({required String phoneNumber}) async {
    ResponseHandler handledResponse =
    ResponseHandler(status: ResponseStatus.error);
    String url =
        '${_isProvider && !isClient ? BaseURL.baseServiceProviderUrl : BaseURL.baseCustomerUrl}/sendotp';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'phone=$phoneNumber',
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
      } else if (response.statusCode == 422 &&
          jsonDecode(response.body)['message'] != null) {
        handledResponse.status = ResponseStatus.failure;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      } else {
        handledResponse.status = ResponseStatus.notFound;
      }

      logMessage(
          location: 'customerSendOTP RESPONSE STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'customerSendOTP RESPONSE',
          message: response.body.toString());
    } catch (e) {
      logMessage(location: 'ERROR ON customerSendOTP', message: e.toString());
      handledResponse.status = ResponseStatus.error;
    }

    return handledResponse;
  }

  Future<ResponseHandler> verifyAccount(
      {required String phoneNumber, required String otp}) async {
    ResponseHandler handledResponse =
        ResponseHandler(status: ResponseStatus.error);
    String url =
        '${_isProvider && !isClient ? BaseURL.baseServiceProviderUrl : BaseURL.baseCustomerUrl}/verify';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'phone=$phoneNumber&otp=$otp',
      );


      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        _accessToken = jsonDecode(response.body)['access_token'];
        storage.write('token', _accessToken);
        notifyListeners();
        await getCustomerUserInfo();
      } else if (jsonDecode(response.body)['message'] != null) {
        handledResponse.status = ResponseStatus.failure;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      } else {
        handledResponse.status = ResponseStatus.notFound;
      }

      logMessage(
          location: 'verifyAccount RESPONSE STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'verifyAccount RESPONSE',
          message: response.body.toString());
    } catch (e) {
      logMessage(location: 'ERROR ON verifyAccount', message: e.toString());
      handledResponse.status = ResponseStatus.error;
    }

    return handledResponse;
  }

  Future<ResponseHandler> CheckOtp(
      {required String phoneNumber, required String otp}) async {
    ResponseHandler handledResponse =
    ResponseHandler(status: ResponseStatus.error);
    String url =
        '${_isProvider && !isClient ? BaseURL.baseServiceProviderUrl : BaseURL.baseCustomerUrl}/checkotp';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'phone=$phoneNumber&message=$otp',
      );

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        _accessToken = jsonDecode(response.body)['access_token'];
        storage.write('token', _accessToken);
        notifyListeners();
        await getCustomerUserInfo();
      } else if (jsonDecode(response.body)['message'] != null) {
        handledResponse.status = ResponseStatus.failure;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      } else {
        handledResponse.status = ResponseStatus.notFound;
      }

      logMessage(
          location: 'verifyAccount RESPONSE STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'verifyAccount RESPONSE',
          message: response.body.toString());
    } catch (e) {
      logMessage(location: 'ERROR ON verifyAccount', message: e.toString());
      handledResponse.status = ResponseStatus.error;
    }

    return handledResponse;
  }

  Future<ResponseHandler> forgotPasswordReset(
      {required String phoneNumber,
      required String password,
      required String confirmPassword,
      required String otp}) async {
    ResponseHandler handledResponse =
        ResponseHandler(status: ResponseStatus.error);
    String url =
        '${_isProvider && !isClient ? BaseURL.baseServiceProviderUrl : BaseURL.baseCustomerUrl}/forgetpassword';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body:
            'phone=$phoneNumber&password=$password&password_confirmation=$confirmPassword&otp=$otp',
      );

print(response.statusCode);
      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
      } else if (response.statusCode == 422 &&
          jsonDecode(response.body)['message'] != null) {
        handledResponse.status = ResponseStatus.failure;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      } else {
        handledResponse.status = ResponseStatus.notFound;
      }

      logMessage(
          location: 'forgotPasswordReset RESPONSE STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'forgotPasswordReset RESPONSE',
          message: response.body.toString());
    } catch (e) {
      logMessage(
          location: 'ERROR ON forgotPasswordReset', message: e.toString());
      handledResponse.status = ResponseStatus.error;
    }

    return handledResponse;
  }

  Future<ResponseHandler> loginAsCustomer(
      {required String phoneNumber,
      String? countryCode,
      required String password}) async {
    ResponseHandler handledResponse =
        ResponseHandler(status: ResponseStatus.error);
    String url = '${BaseURL.baseCustomerUrl}/login';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'phone=$phoneNumber&password=$password',
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        _accessToken = jsonDecode(response.body)['access_token'];
        storage.write('token', _accessToken);
        notifyListeners();
        await getCustomerUserInfo();
      } else if (jsonDecode(response.body)['message'] != null) {
        handledResponse.status = ResponseStatus.failure;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'LOGIN RESPONSE STATUS CODE', message: response.statusCode);
      logMessage(location: 'LOGIN RESPONSE', message: response.body.toString());
    } catch (e) {
      logMessage(location: 'ERROR ON SIGN IN', message: e.toString());
      handledResponse.status = ResponseStatus.error;
    }

    return handledResponse;

    // changeIsLoading(false);
  }

  Future<ResponseHandler> signUpAsProvider(
      {required String fullName,
      required String phoneNumber,
      required String password,
      required String passwordConfirmation,
      required File idFront,
      // required File idBack,
      required File idSelfie,
      required int categoryId,
      required List<int> subCategoryIds,
      required String about,
      required String invite_link,
   required File image,
      required int cityId,
      required String passport}) async {
    ResponseHandler handledResponse =
        ResponseHandler(status: ResponseStatus.error);
    String url = '${BaseURL.baseServiceProviderUrl}/register';
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'Accept': 'application/json',
      });
      request.fields.addAll({
        'name': fullName,
        'phone': phoneNumber,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'category_id': categoryId.toString(),
        'about': about,
        'passport': passport,
        'invite_token': invite_link,
        'city_id': cityId.toString(),
        for (int i = 0; i < subCategoryIds.length; i++)
          'subcategory[$i]': subCategoryIds[i].toString(),
      });
      // add files
      request.files.add(http.MultipartFile.fromBytes(
          'id[front]', await idFront.readAsBytes(),
          filename: idFront.path.split('/').last));
      // request.files.add(http.MultipartFile.fromBytes(
      //     'id[back]', await idBack.readAsBytes(),
      //     filename: idBack.path.split('/').last));
      request.files.add(http.MultipartFile.fromBytes(
          'id[selfie]', await idSelfie.readAsBytes(),
          filename: idSelfie.path.split('/').last));
      request.files.add(http.MultipartFile.fromBytes(
          'image', await image.readAsBytes(),
          filename: image.path.split('/').last));

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
      } else if (response.statusCode == 422 ) {
        handledResponse.status = ResponseStatus.duplicate;
        handledResponse.errorMessage =
            jsonDecode(await response.stream.bytesToString())['message'];

        print(handledResponse.errorMessage);
      } else {
        handledResponse.status = ResponseStatus.error;
        handledResponse.errorMessage =
            jsonDecode(await response.stream.bytesToString())['message'];
        print(errorMessage);
      }
      print(errorMessage);

    } catch (e) {
      logMessage(location: 'ERROR ON signUpAsProvider', message: e.toString());
      handledResponse.status = ResponseStatus.error;
      print(errorMessage);
    }

    return handledResponse;

    // changeIsLoading(false);
  }

  Future<ResponseHandler> loginAsProvider(
      {required String phoneNumber,
      String? countryCode,
      required String password}) async {
    ResponseHandler handledResponse =
        ResponseHandler(status: ResponseStatus.error);
    String url = '${BaseURL.baseServiceProviderUrl}/login';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'phone=$phoneNumber&password=$password',
      );

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        _accessToken = jsonDecode(response.body)['access_token'];
        storage.write('token', _accessToken);
        notifyListeners();
        await getProviderUserInfo();
        await NotificationsProvider(_accessToken).fetchNotifications();
      } else if (jsonDecode(response.body)['message'] != null) {
        handledResponse.status = ResponseStatus.failure;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'loginAsProvider RESPONSE STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'loginAsProvider RESPONSE',
          message: response.body.toString());
    } catch (e) {
      logMessage(location: 'ERROR ON loginAsProvider', message: e.toString());
      handledResponse.status = ResponseStatus.error;
    }

    return handledResponse;

    // changeIsLoading(false);
  }

  Future<ResponseHandler> updateCustomerProfile(
      {required String name, String? emailAddress, XFile? profileImage}) async {
    ResponseHandler handledResponse =
        ResponseHandler(status: ResponseStatus.error);
    String url = '${BaseURL.baseCustomerUrl}/profile';
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Bearer $_accessToken',
      });
      request.fields.addAll({
        'name': name,
        'email': emailAddress ?? '',
      });

      if (profileImage != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', profileImage.path));
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        await getCustomerUserInfo();
      } else {
        handledResponse.status = ResponseStatus.error;
        handledResponse.errorMessage = 'Failed to update profile';
      }
    } catch (e) {
      print('Error updating profile: $e');
    }

    return handledResponse;
  }

  Future<ResponseHandler> updateProviderProfile({
    required String name,
    String? emailAddress,
    String? about,
    String? phone,
    XFile? profileImage,
  }) async {
    ResponseHandler handledResponse =
        ResponseHandler(status: ResponseStatus.error);
    String url = '${BaseURL.baseServiceProviderUrl}/profile';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $_accessToken',
      });

      request.fields.addAll({
        'name': name,
        'email': emailAddress ?? '',
        'about': about ?? '',
        'phone': phone ?? '',
      });

      if (profileImage != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', profileImage.path));
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        await getProviderUserInfo();
        notifyListeners(); //
      } else {
        handledResponse.status = ResponseStatus.error;
        handledResponse.errorMessage = 'فشل تحديث الملف الشخصي';
      }
    } catch (e) {
      print('Error updating profile: $e');
      handledResponse.status = ResponseStatus.error;
    }

    return handledResponse;
  }

  Future tryAutoLogin() async {
    final token = storage.read('token');
    if (token != null) {
      _accessToken = token;
      final String userType = storage.read('user_type');
      _isClient = userType == 'customer';
      _isProvider = userType == 'provider';
      notifyListeners();

      if (userType == 'customer') {
        await getCustomerUserInfo();
      } else if (userType == 'provider') {
        await getProviderUserInfo();
        await NotificationsProvider(_accessToken).fetchNotifications();
      }
    }
  }

  getCustomerUserInfo() async {
    String url = '${BaseURL.baseCustomerUrl}/profile';
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer $_accessToken',
        },
      );

      await checkResponseHttp(response);
      NotificationsProvider(_accessToken).setFCMDeviceToken();

      if (response.statusCode == 200) {
        _customer = customerFromJson(jsonDecode(response.body)['data']);
        setCustomerUserInfo(_customer!);
      }

      logMessage(
          location: 'getCustomerUserInfo STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'getCustomerUserInfo RESPONSE',
          message: response.body.toString());
    } catch (e) {
      logMessage(
          location: 'ERROR ON getCustomerUserInfo', message: e.toString());
    }
  }

  setCustomerUserInfo(Customer customer) async {
    _customer = customer;
    notifyListeners();
    storage.write('user_data', _customer?.toJson());
    storage.write('user_type', 'customer');
  }

  getProviderUserInfo() async {
    String url = '${BaseURL.baseServiceProviderUrl}/profile';
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer $_accessToken',
        },
      );

      await checkResponseHttp(response);
      NotificationsProvider(_accessToken).setFCMDeviceToken();

      if (response.statusCode == 200) {
        _provider =
            serviceProviderAccountFromJson(jsonDecode(response.body)['data']);

        storage.write('id_provider', _provider!.id);
        storage.write('wallet_provider', _provider!.wallet);
        await setProviderUserInfo(_provider!);
      }

      logMessage(
          location: 'getProviderUserInfo STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'getProviderUserInfo RESPONSE',
          message: response.body.toString());
    } catch (e) {
      logMessage(
          location: 'ERROR ON getProviderUserInfo', message: e.toString());
    }
  }

  setProviderUserInfo(ServiceProviderAccount provider) async {
    _provider = provider;
    notifyListeners();
    storage.write('user_data', _provider?.toJson());
    storage.write('user_type', 'provider');
  }

  logout() async {
    _isAuth = false;
    _accessToken = null;
    _customer = null;
    _provider = null;
    storage.remove('token');
    storage.remove('user_data');
    storage.remove('user_type');
    notifyListeners();
  }

  changeIsLoginScreen(bool value) {
    isLoginScreen = value;
    notifyListeners();
  }

  changeToClientOrProvider(bool isClient) {
    if (isClient) {
      _isClient = true;
      _isProvider = false;
    } else {
      _isClient = false;
      _isProvider = true;
    }

    notifyListeners();
  }

  Future<ResponseHandler> deleteAccount() async {
    ResponseHandler handledResponse =
        ResponseHandler(status: ResponseStatus.error);
    String url =
        '${_isProvider && !isClient ? BaseURL.baseServiceProviderUrl : BaseURL.baseCustomerUrl}/deleteaccount';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        logout();
      } else if (jsonDecode(response.body)['message'] != null) {
        handledResponse.status = ResponseStatus.failure;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'deleteAccount RESPONSE STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'deleteAccount RESPONSE',
          message: response.body.toString());
    } catch (e) {
      logMessage(location: 'ERROR ON deleteAccount', message: e.toString());
      handledResponse.status = ResponseStatus.error;
    }

    return handledResponse;
  }

  Future<ResponseHandler> checkPhoneNumber(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('${isProvider && !isClient ? BaseURL.baseServiceProviderUrl : BaseURL.baseCustomerUrl}/otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: 'phone=$phoneNumber',
      );

      if (response.statusCode == 200) {
        return ResponseHandler(status: ResponseStatus.success);
      } else if (response.statusCode == 404) {
        return ResponseHandler(status: ResponseStatus.error);
      } else {
        return ResponseHandler(
          status: ResponseStatus.error,
          errorMessage: 'حدث خطأ أثناء التحقق من رقم الهاتف',
        );
      }
    } catch (e) {
      return ResponseHandler(
        status: ResponseStatus.error,
        errorMessage: 'حدث خطأ أثناء التحقق من رقم الهاتف',
      );
    }
  }
}
