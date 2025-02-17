// Auth
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

class AppUser {
  AppUser({
    required this.id,
    required this.email,
    required this.username,
  });

  final String id;
  final String email;
  final String username;

  AppUserGardenRecord? latestGardenRecord;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser && other.id == id && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  @override
  String toString() => 'AppUser(id: $id, email: $email)';
}