import 'dart:convert';
import 'package:dio/dio.dart';

final String baseUrl = 'http://localhost:8008/';

class Api {
  var dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 15000,
      receiveTimeout: 100000,
      receiveDataWhenStatusError: true,
      // contentType: Headers.formUrlEncodedContentType
    ),
  );

  Future<Response<dynamic>> request(
      String method, String route, Map<String, dynamic> data) async {
    String url = baseUrl + route;
    print("API Request:");
    print(method);
    print(url);
    print("Data: " + data.toString());
    try {
      Response response = method == 'POST'
          ? await dio.post(url, data: data)
          : await dio.get(url, queryParameters: data);
      print("Status: " + response.statusCode.toString());
      print("Response: " + response.toString());
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      print('Dio error: ' + errorMessage);
      return null;
    }
  }

  Future<dynamic> get(String route, Map<String, dynamic> query) async {
    Response response = await request("GET", route, query);
    return json.decode(response.toString());
  }

  Future<dynamic> post(String route, Map<String, dynamic> body) async {
    Response response = await request("POST", route, body);
    return json.decode(response.toString());
  }
}

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.CANCEL:
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.DEFAULT:
        message = "Connection to API server failed due to internet connection";
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.RESPONSE:
        message =
            _handleError(dioError.response.statusCode, dioError.response.data);
        break;
      case DioErrorType.SEND_TIMEOUT:
        message = "Send timeout in connection with API server";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String message;

  String _handleError(int statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 404:
        return error.toString();
      case 500:
        return 'Internal server error';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
