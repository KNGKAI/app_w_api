import 'dart:convert';
import 'package:dio/dio.dart';

// final String baseUrl = 'http://localhost:8008/';
final String baseUrl = 'https://012sktate-server.azurewebsites.net/';

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

  Future<Response> request(
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
      case DioErrorType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.connectTimeout:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        message =
            _handleError(dioError.response.statusCode, dioError.response.data);
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      case DioErrorType.other:
        message = "Something went wrong";
        break;
      default:
        message = "Connection to API server failed due to internet connection";
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
