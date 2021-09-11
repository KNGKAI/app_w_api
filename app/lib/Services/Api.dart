import 'dart:convert';
import 'package:dio/dio.dart';

class APIResponse {
  String url;
  String method;
  bool success;
  String message;
  dynamic body;

  APIResponse({
    this.url,
    this.method,
    this.success,
    this.message,
    this.body,
  });

  @override
  String toString() => 'APIResponse{'
      'url: $url,'
      'method: $method,'
      'success: $success,'
      'message: $message,'
      'body: $body'
      '}';
}

class Api {
  // static String host = 'http://localhost:8008/';
  static String host = 'https://012sktate-server.azurewebsites.net/';

  var dio = Dio(
    BaseOptions(
        baseUrl: Api.host,
        connectTimeout: 150000,
        receiveTimeout: 1000000,
        receiveDataWhenStatusError: true,
        // contentType: Headers.formUrlEncodedContentType
        headers: {"Access-Control-Allow-Origin": "*"}),
  );

  Future<APIResponse> request(
      String method, String route, Map<String, dynamic> data) async {
    String url = Api.host + route;
    print("API Request:");
    print("Method: $method");
    print("URL: $url");
    print("Data: " + data.toString());
    APIResponse apiResponse = APIResponse(
        url: url, method: method, success: false, message: "none", body: null);
    try {
      Response response = method == 'POST'
          ? await dio.post(url, data: data)
          : await dio.get(url, queryParameters: data);
      if (response != null) {
        print("Status: " + response.statusCode.toString());
        print("Response: " + response.toString());
        apiResponse.success = true;
        apiResponse.message = "success";
        apiResponse.body = json.decode(response.toString());
      } else {
        print("Request Failed");
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse.message = errorMessage;
      print('Dio error: ' + errorMessage);
    }
    return apiResponse;
  }

  Future<APIResponse> get(String route, Map<String, dynamic> query) =>
      request("GET", route, query);

  Future<APIResponse> post(String route, Map<String, dynamic> body) =>
      request("POST", route, body);
}

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioError dioError) {
    print(dioError.type);
    print(dioError.response.statusCode);
    print(dioError.response.data);
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
        if (dioError.response == null) {
          message = dioError.toString();
        } else {
          message = _handleError(
              dioError.response.statusCode, dioError.response.data);
        }
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      case DioErrorType.other:
        message =
            "Something went wrong: " + dioError.error?.toString() ?? "null";
        break;
      default:
        message = "Connection to API server failed due to internet connection";
        break;
    }
  }

  String message;

  String _handleError(int statusCode, dynamic error) {
    // switch (statusCode) {
    //   case 400:
    //     return 'Bad request';
    //   case 404:
    //     return error.toString();
    //   case 500:
    //     return 'Internal server error';
    //   default:
    //     return 'Oops something went wrong: ' + ;
    // }
    return "Error ${statusCode?.toString() ?? "null"}: ${error?.toString() ?? "null"}";
  }

  @override
  String toString() => message;
}
