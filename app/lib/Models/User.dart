class User {
  String id;
  String first;
  String last;
  String username;
  String email;
  String phone;
  String role;
  List<String> chat;

  User.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    id = json['id'] ?? json['_id'];
    first = json['first'];
    last = json['last'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
    chat = <String>[...json['chat']];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "first": first,
        "last": last,
        "username": username,
        "email": email,
        "phone": phone,
        "role": role,
        "chat": chat,
      };

  User({
    this.id,
    this.first,
    this.last,
    this.username,
    this.email,
    this.phone,
    this.role,
    this.chat,
  });
}
