// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart'
  show getUserGardenRoleFromString;
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

enum AppUserGardenRole {
  owner(displayName: "Owner", priority: 2),
  administrator(displayName: "Administrator", priority: 1),
  member(displayName: "Member", priority: 0);

  const AppUserGardenRole({
    required this.priority,
    required this.displayName,
  });

  final String displayName;
  final int priority;
}

enum AppUserGardenPermission {
  changeGardenName,
  changeMemberRoles,
  changeOwner,
  createAndEditAsks,
  createInvitations,
  deleteGarden,
  deleteMemberAsks,
  expelMembers,
  viewAdminGardenTimeline,
  viewAllUsers,
  viewAuditLog,
  viewGardenTimeline
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
      role = getUserGardenRoleFromString(json[UserGardenRecordField.role])!,
      user = recordUser;

  Map<String, dynamic> toMap() {
    return {
      GenericField.id: id,
      UserGardenRecordField.garden: garden.id,
      UserGardenRecordField.role: role.name,
      UserGardenRecordField.user: user.id
    };
  }

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