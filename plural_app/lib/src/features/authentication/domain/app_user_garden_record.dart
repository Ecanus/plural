// Constants
import 'package:get_it/get_it.dart';
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart'
  show getUserGardenRoleFromString;
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

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
  editDoDocument,
  expelMembers,
  viewActiveInvitations,
  viewAdminGardenTimeline,
  viewAllUsers,
  viewAuditLog,
  viewGardenTimeline
}

class AppUserGardenRecord {
  AppUserGardenRecord({
    required this.garden,
    required this.doDocumentReadDate,
    required this.id,
    required this.role,
    required this.user,
  });

  final Garden garden;
  final DateTime doDocumentReadDate;
  final String id;
  final AppUserGardenRole role;
  final AppUser user;

  AppUserGardenRecord.fromJson(
    Map<String, dynamic> json, AppUser recordUser, Garden recordGarden) :
      garden = recordGarden,
      doDocumentReadDate = DateTime.parse(json[UserGardenRecordField.doDocumentReadDate]),
      id = json[GenericField.id] as String,
      role = getUserGardenRoleFromString(json[UserGardenRecordField.role])!,
      user = recordUser;

  bool get hasReadDoDocument {
    return doDocumentReadDate.isAfter(
      GetIt.instance<AppState>().currentGarden!.doDocumentEditDate);
  }

  Map<String, dynamic> toMap() {
    return {
      GenericField.id: id,
      UserGardenRecordField.garden: garden.id,
      UserGardenRecordField.doDocumentReadDate: doDocumentReadDate,
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