// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart' show AppUserGardenRole;

class AppUser {
  AppUser({
    required this.firstName,
    required this.id,
    required this.lastName,
    required this.username,
  });

  final String firstName;
  final String id;
  final String lastName;
  final String username;

  AppUser.fromJson(Map<String, dynamic> json) :
    firstName = json[UserField.firstName] as String,
    id = json[GenericField.id] as String,
    lastName = json[UserField.lastName] as String,
    username = json[UserField.username] as String;

  Map<String, dynamic> toMap() {
    return {
      UserField.firstName: firstName,
      GenericField.id: id,
      UserField.lastName: lastName,
      UserField.username: username
    };
  }

  /// Checks if the AppUser has an AppUserGardenRecord.role of priority
  /// greater than or equal to [role].
  ///
  /// Returns true if the priority is greater than or equal to [role],
  /// else false.
  Future<bool> hasRole(String gardenID, AppUserGardenRole role) async {
    final userGardenRecord = await getUserGardenRecord(userID: id, gardenID: gardenID);

    if (userGardenRecord == null) return false;

    return userGardenRecord.role.priority >= role.priority;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser && other.id == id && other.username == username;
  }

  @override
  int get hashCode => id.hashCode ^ username.hashCode;

  @override
  String toString() => "AppUser(id: $id, username: $username)";
}