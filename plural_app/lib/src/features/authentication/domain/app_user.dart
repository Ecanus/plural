// Constants
import 'package:plural_app/src/constants/fields.dart';

class AppUser {
  AppUser({
    required this.email,
    required this.id,
    required this.username,
  });

  final String email;
  final String id;
  final String username;

  AppUser.fromJson(Map<String, dynamic> json) :
    email = json[UserField.email] as String,
    id = json[GenericField.id] as String,
    username = json[UserField.username] as String;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser && other.id == id && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  @override
  String toString() => "AppUser(id: $id, username: $username, email: $email)";
}