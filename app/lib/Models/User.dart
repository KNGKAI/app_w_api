// import 'package:google_maps_flutter/google_maps_flutter.dart';

class User {
  String id;
  String email;
  String username;
  String address;
  String role;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['_id'];
    email = json['email'];
    username = json['username'];
    address = json['address'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "address": address,
        "role": role,
      };

  User({
    this.id,
    this.email,
    this.username,
    this.address,
    this.role,
  });
}
