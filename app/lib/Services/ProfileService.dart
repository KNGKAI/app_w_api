import 'dart:io';
import 'package:app/Models/User.dart';
import 'package:app/Services/Api.dart';
import 'package:app/Services/SharedPreferenceService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  final Api _api;

  ProfileService({Api api}) : _api = api;

  static String _token;
  static User _user;

  bool get authorized => _user != null;
  User get user => _user;
  String get token => _token;

  static void setToken(String token) async {
    _token = token;
    SharedPreferenceService.setToken(token);
  }

  Future<bool> registerUser(User user, String password) async {
    Map<String, dynamic> response = await _api.post('user/register', {
      "username": user.username,
      "email": user.email,
      "password": password
    });
    return response != null;
  }

  Future<bool> authorizeUser(String username, String password) async {
    Map<String, dynamic> response = await _api
        .post('auth/local', {"username": username, "password": password});
    if (response != null) {
      _user = User.fromJson(response['user']);
      _token = response['token'];
      setToken(_token);
      return true;
    }
    return false;
  }

  Future<bool> tokenAuthorizeUser(String token) async {
    Map<String, dynamic> response =
        await _api.post('auth/token', {"token": token});
    if (response != null) {
      _user = User.fromJson(response['user']);
      _token = response['token'];
      setToken(_token);
      return true;
    }
    return false;
  }

  Future<bool> signOutUser() async {
    _user = null;
    _token = null;
    setToken(null);
    return true;
  }

  Future<bool> updateUser(User user) async {
    Map<String, dynamic> response = await _api.post('api/user/update', {
      "token": _token,
      "id": user.id,
      "email": user.email,
      "username": user.username,
    });
    if (response != null) {
      _user = User.fromJson(response['user']);
      // _token = response['token'];
      // setToken(_token);
      return true;
    }
    return false;
  }
}
