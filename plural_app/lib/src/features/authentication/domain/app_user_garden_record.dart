// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart'
  show getUserGardenRoleFromString;
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

enum AppUserGardenRole {
  member(priority: 0),
  moderator(priority: 1),
  owner(priority: 2);

  const AppUserGardenRole({
    required this.priority
  });

  final int priority;
}

enum AppUserGardenPermission {
  changeGardenName,
  changeMemberRoles,
  createAsks,
  createInvitations,
  deleteGarden,
  deleteMemberAsks,
  enterModView,
  kickMembers,
  viewAuditLog,
}

class AppUserGardenRecord {
  AppUserGardenRecord({
    required this.garden,
    required this.id,
    required this.role,
    required this.user,
  });

  final Garden garden;
  final String id;
  final AppUserGardenRole role;
  final AppUser user;

  AppUserGardenRecord.fromJson(
    Map<String, dynamic> json, AppUser recordUser, Garden recordGarden) :
      garden = recordGarden,
      id = json[GenericField.id] as String,
      role = getUserGardenRoleFromString(json[UserGardenRecordField.role]),
      user = recordUser;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUserGardenRecord
      && other.id == id
      && other.garden == garden
      && other.user == user;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => ""
    "AppUserGardenRecord(id: $id, user: ${user.id}, garden: ${garden.id}, "
    "role: ${role.toString()})";
}