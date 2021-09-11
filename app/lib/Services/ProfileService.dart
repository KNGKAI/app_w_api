import 'dart:io';
import 'package:skate/Models/User.dart';
import 'package:skate/Services/Api.dart';
import 'package:skate/Services/SharedPreferenceService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  final Api _api;

  ProfileService({Api api}) : _api = api;

  static String _token;
  static User _user;

  bool get authorized => _user != null;
  User get user => _user;
  String get token => _token;

  Future<void> init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _token = preferences.getString('token');
    if (_token != null) {
      APIResponse response =
          await _api.post('auth/token', {"token": _token});
      if (response.success) {
        _user = User.fromJson(response.body['user']);
        _token = response.body['token'];
        setToken(_token);
      }
    }
  }

  Future<APIResponse> authorizeUser(String username, String password) async {
    APIResponse response = await _api
        .post('auth/local', {"username": username, "password": password});
    if (response.success) {
      _user = User.fromJson(response.body['user']);
      _token = response.body['token'];
      setToken(_token);
    }
    return response;
  }

  Future<APIResponse> registerUser(User user, String password) async {
    APIResponse response = await _api.post('user/register', {
      "first": user.first,
      "last": user.last,
      "username": user.username,
      "email": user.email,
      "password": password
    });
    return response;
  }

  static void setToken(String token) async {
    _token = token;
    SharedPreferenceService.setToken(token);
  }

  Future<bool> signOutUser() async {
    _user = null;
    _token = null;
    setToken(null);
    return true;
  }

  Future<APIResponse> tokenAuthorizeUser(String token) async {
    APIResponse response = await _api.post('auth/token', {"token": token});
    if (response.success) {
      _user = User.fromJson(response.body['user']);
      _token = response.body['token'];
      setToken(_token);
    }
    return response;
  }

  Future<APIResponse> updateUser(User user) async {
    APIResponse response = await _api.post('user/update', {
      "token": _token,
      "id": user.id,
      "email": user.email,
      "username": user.username,
    });
    if (response.success) {
      _user = User.fromJson(response.body['user']);
    }
    return response;
  }

  Future<APIResponse> postMessage(User user, String message) =>
      _api.post('user/message', {
        "user": user.id,
        "message": message,
      });
}
