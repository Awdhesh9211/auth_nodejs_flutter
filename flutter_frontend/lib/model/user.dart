import 'dart:convert';

class User {
  final String name;
  final String email;

  User({
    required this.name,
    required this.email,
  });

  // Convert User to a Map (for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }

  // Convert User to JSON
  String toJson() => json.encode(toMap());

  // Convert Map to User (for deserialization)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      email: map['email'],
    );
  }

  // Convert JSON to User
  factory User.fromJson(String source) {
    return User.fromMap(json.decode(source));
  }
}
