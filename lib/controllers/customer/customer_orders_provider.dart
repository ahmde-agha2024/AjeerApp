import 'dart:convert';
import 'dart:io';

import 'package:ajeer/constants/domain.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/models/common/category_model.dart';
import 'package:ajeer/models/common/service_details_model.dart';
import 'package:ajeer/models/customer/service_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../../main.dart';

class CustomerOrdersProvider with ChangeNotifier {
  final String? _accessToken; // comes from Auth() provider
  bool isLoading = false;
  double orderRating = 5.0;
  final TextEditingController notesController = TextEditingController();

  CustomerOrdersProvider(this._accessToken);
  void setOrderRating(double rating) {
    orderRating = rating;
    notifyListeners();
  }

  Future<ResponseHandler<ServiceResponse>> fetchCustomerServices() async {
    ResponseHandler<ServiceResponse> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/service';
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
        ServiceResponse serviceResponse =
            serviceResponseFromJson(response.body);

        handledResponse.response = serviceResponse;
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'fetchCustomerServices STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'fetchCustomerServices RESPONSE',
          message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON fetchCustomerServices',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<void> submitRating({
    required int serviceId,
    required double serviceRating,
    required String notes,
  }) async {
    String url = '${BaseURL.baseCustomerUrl}/rates';
    var data = {
      'service_id': serviceId.toString(),
      'rate': serviceRating.round().toString(),
      'comment': notes,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $_accessToken',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(content: Text('تم التقييم بنجاح')),
        );
        fetchCustomerServices();
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'حدث خطأ أثناء التقييم';
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }

      logMessage(
          location: 'submitRating STATUS CODE', message: response.statusCode);
      logMessage(
          location: 'submitRating RESPONSE', message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON submitRating',
          message: e.toString(),
          stack: s.toString());
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء التقييم')),
      );
    }
  }

  Future<ResponseHandler> requestNewService({
    required String title,
    required String content,
    required double price,
    required int categoryId,
    required int subCategoryId,
    required int addressId,
    required String date,
    required String time,
    required String status,
    required List<File>? serviceImages,
    int? provider_id
  }) async {
    ResponseHandler handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/service';

    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $_accessToken'
      });
      request.fields.addAll({
        "title": title,
        "content": content,
        "price": price.toString(),
        "category_id": categoryId.toString(),
        "subcategory_id": subCategoryId.toString(),
        "address_id": addressId.toString(),
        "date": date,
        "time": time,
        "service_status" : status,
        "provider_id":provider_id.toString()
      });

      // TODO:: FIX THIS
      // if (!await checkResponseHttp(response)) {
      //   return handledResponse;
      // }

      if (serviceImages!.isNotEmpty) {
        request.files.add(http.MultipartFile(
            'image',
            serviceImages!.first.readAsBytes().asStream(),
            serviceImages!.first.lengthSync(),
            filename: basename(serviceImages!.first.path)));

        for (var imageElement in serviceImages!) {
          // TODO: FIX LATER TO ADD REQUEST IMAGES
          // request.files.add(http.MultipartFile('gallery[]', imageElement.readAsBytes().asStream(), imageElement.lengthSync(), filename: basename(imageElement.path)));
        }
      }

      var response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
      } else {
        handledResponse.status = ResponseStatus.error;
        handledResponse.errorMessage = jsonDecode(responseBody)['message'];
      }

      logMessage(
          location: 'requestNewService STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'requestNewService RESPONSE',
          message: responseBody.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON requestNewService',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }


  Future<ResponseHandler<ServiceDetails>> fetchSingleCustomerService(
      int serviceId) async {
    ResponseHandler<ServiceDetails> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/service/$serviceId';
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
        ServiceDetails serviceDetails = serviceDetailsFromJson(response.body);

        handledResponse.response = serviceDetails;
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'fetchSingleCustomerService STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'fetchSingleCustomerService RESPONSE',
          message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON fetchSingleCustomerService',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler> acceptServiceOffer(int offerId) async {
    ResponseHandler handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/acceptoffer';
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer $_accessToken',
        },
        body: 'offer_id=$offerId',
      );

      if (!await checkResponseHttp(response)) {
        return handledResponse;
      }
print(response.statusCode);
      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
      } else if (jsonDecode(response.body)['message'] != null) {
        handledResponse.status = ResponseStatus.error;
        handledResponse.errorMessage = jsonDecode(response.body)['message'];
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'acceptServiceOffer STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'acceptServiceOffer RESPONSE',
          message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON acceptServiceOffer',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler> cancelAServiceRequest(
      int serviceId, String cancellationReason) async {
    ResponseHandler handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/servicecancel';
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer $_accessToken',
        },
        body: 'service_id=$serviceId&reason=$cancellationReason',
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

      logMessage(
          location: 'cancelAServiceRequest STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'cancelAServiceRequest RESPONSE',
          message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON cancelAServiceRequest',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler> deleteServiceRequest(int serviceId) async {
    ResponseHandler handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/service/$serviceId';
    try {
      http.Response response = await http.delete(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer $_accessToken',
        },
        body: 'service_id=$serviceId',
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

      logMessage(
          location: 'deleteServiceRequest STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'deleteServiceRequest RESPONSE',
          message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON deleteServiceRequest',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler> finishServiceRequest(int serviceId) async {
    ResponseHandler handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/finish';
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer $_accessToken',
        },
        body: 'service_id=$serviceId',
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

      logMessage(
          location: 'finishServiceRequest STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'finishServiceRequest RESPONSE',
          message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON finishServiceRequest',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }

  Future<ResponseHandler<List<Category>>> fetchSubCategories(
      int categoryId) async {
    ResponseHandler<List<Category>> handledResponse =
        ResponseHandler(status: ResponseStatus.error);

    String url = '${BaseURL.baseCustomerUrl}/category/$categoryId';
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        handledResponse.status = ResponseStatus.success;
        notifyListeners();

        handledResponse.response = categoryListFromJson(
            jsonDecode(response.body)['data']['sub_categories']);
      } else {
        handledResponse.status = ResponseStatus.error;
      }

      logMessage(
          location: 'fetchSubCategories STATUS CODE',
          message: response.statusCode);
      logMessage(
          location: 'fetchSubCategories RESPONSE',
          message: response.body.toString());
    } catch (e, s) {
      logMessage(
          location: 'ERROR ON fetchSubCategories',
          message: e.toString(),
          stack: s.toString());
    }
    return handledResponse;
  }
}
