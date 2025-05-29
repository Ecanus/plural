// Constants
import 'package:plural_app/src/constants/fields.dart';

class AppUser {
  AppUser({
    required this.email,
    required this.firstName,
    required this.id,
    required this.lastName,
    required this.username,
  });

  final String email;
  final String firstName;
  final String id;
  final String lastName;
  final String username;

  AppUser.fromJson(Map<String, dynamic> json) :
    email = json[UserField.email] as String,
    firstName = json[UserField.firstName] as String,
    id = json[GenericField.id] as String,
    lastName = json[UserField.lastName] as String,
    username = json[UserField.username] as String;

  Map toMap() {
    return {
      UserField.email: email,
      UserField.firstName: firstName,
      GenericField.id: id,
      UserField.lastName: lastName,
      UserField.username: username
    };
  }

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