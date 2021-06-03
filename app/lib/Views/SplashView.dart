import 'dart:async';

import 'package:app/Widgets/Logo.dart';
import 'package:flutter/material.dart';
import 'package:app/Services/ProfileService.dart';
import 'package:app/Services/SharedPreferenceService.dart';

import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashView createState() => _SplashView();
}

class _SplashView extends State<SplashView> {
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
    String token = SharedPreferenceService.getToken();
    Function handleUser = () async {
      print("token: " + token.toString());
      Timer(Duration(seconds: 1), () async {
        if (token == null) {
          Navigator.of(context).pushReplacementNamed('/login');
        } else {
          if (await profileService.tokenAuthorizeUser(token)) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        }
      });
    };
    if (!_initialized) {
      handleUser();
      _initialized = true;
    }
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(child: Logo(color: Colors.blue)),
      ),
    );
  }
}
