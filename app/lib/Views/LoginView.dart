import 'package:flutter/material.dart';
import 'package:skate/Widgets/Logo.dart';
import 'package:provider/provider.dart';
import 'package:skate/Services/Api.dart';
import 'package:skate/Services/ProfileService.dart';

class LoginView extends StatefulWidget {
  @override
  _State createState() => _State();
}

Widget spacedButton(child) {
  return Padding(padding: EdgeInsets.only(top: 7, bottom: 7), child: child);
}

class _State extends State<LoginView> {
  TextEditingController _oldPasswordController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _forgottenController;
  TextEditingController _confirmationController;
  bool _obscureText;
  String _loginErrorText = '';
  String _userCommunication = '';

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _forgottenController = TextEditingController();
    _confirmationController = TextEditingController();
    _oldPasswordController = TextEditingController();
    toggleShowPassword();

    super.initState();
  }

  void toggleShowPassword() {
    if (_obscureText == null) {
      _obscureText = true;
    } else {
      setState(() {
        _obscureText = (_obscureText) ? false : true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of(context);
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Logo(),
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          Text(_loginErrorText),
          Row(
            children: [
              Checkbox(
                value: (_obscureText) ? false : true,
                onChanged: (val) {
                  toggleShowPassword();
                },
              ),
              Center(
                child: Text('Show Password?'),
              ),
            ],
          ),
          MaterialButton(
            child: Text('Forgot password'),
            onPressed: () async {
              print('Forgot password');
            },
          ),
          MaterialButton(
            color: Colors.red,
            child: Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
          ),
          MaterialButton(
            color: Colors.blue,
            child: Text('Continue with Facebook',
                style: TextStyle(color: Colors.white)),
            onPressed: () async {
              print("facebook login");
            },
          ),
          MaterialButton(
            color: Colors.green,
            child: Text('Login', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              print('logging in...');
              if (await profileService.authorizeUser(
                  _emailController.text, _passwordController.text)) {
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                setState(() {
                  _loginErrorText = 'Login Failed';
                });
              }
            },
          ),
          Text(_userCommunication),
        ],
      ),
    );
  }
}
