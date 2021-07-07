// import 'package:google_maps_flutter/google_maps_flutter.dart';

class User {
  String id;
  String email;
  String username;
  String address;
  String role;
  int budget;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['_id'];
    email = json['email'];
    username = json['username'];
    address = json['address'];
<<<<<<< HEAD
    budget = json['budget'] != null ? int.parse(json['budget'].toString()) : 0;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "address": address,
        "role": role,
      };
=======
    role = json['role'];
    budget = int.parse(json['budget']?.toString() ?? "-1");
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "username": username,
    "address": address,
    "role": role,
    "budget": budget,
  };
>>>>>>> main

  User({
    this.id,
    this.email,
    this.username,
    this.address,
    this.role,
    this.budget,
  });
}
