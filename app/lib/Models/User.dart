// import 'package:google_maps_flutter/google_maps_flutter.dart';

class User {
  String _id;
  String email;
  String username;

  get id => _id;

  User.fromJson(Map<String, dynamic> json) {
    _id = json['_id'];
    email = json['email'];
    username = json['username'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'email': this.email,
      'username': this.username,
    };
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
      };

  User.create() {
    _id = '';
    email = '';
    username = '';
  }

  User({
    String id,
    this.email,
    this.username,
  }) : _id = id;
}
