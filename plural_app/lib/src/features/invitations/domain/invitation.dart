// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_api.dart';

enum InvitationType {
  open,
  private
}

class Invitation {
  Invitation({
    required this.creator,
    required this.createdDate,
    required this.expiryDate,
    required this.garden,
    required this.id,
    required this.type,
    this.usernameOrEmail,
    this.uuid
  }) : assert(
    usernameOrEmail == null || uuid == null,
    "Cannot provide both usernameOrEmail and uuid"
  ),
  assert(
    (type == InvitationType.open && uuid != null) ||
    (type == InvitationType.private && usernameOrEmail != null),
    "Open Invitations require uuid, private Invitations require usernameOrEmail"
  );

  final AppUser creator;
  final DateTime createdDate;
  final DateTime expiryDate;
  final Garden garden;
  final String id;
  final InvitationType type;
  final String? usernameOrEmail;
  final String? uuid;

  Invitation.fromJson(Map<String, dynamic> json, this.creator, this.garden) :
    createdDate = DateTime.parse(json[GenericField.created]),
    expiryDate = DateTime.parse(json[InvitationField.expiryDate]),
    id = json[GenericField.id] as String,
    type = getInvitationTypeFromString(json[InvitationField.type])!,
    usernameOrEmail = json[InvitationField.usernameOrEmail],
    uuid = json[InvitationField.uuid];

  static Map emptyMap() {
    return {
      InvitationField.creator: null,
      InvitationField.expiryDate: null,
      InvitationField.garden: null,
      InvitationField.type: null,
      InvitationField.usernameOrEmail: null,
      InvitationField.uuid: null,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Invitation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    switch (type) {
      case InvitationType.open:
        return ""
          "Invitation(id: $id, garden: '${garden.name}', "
          "creator: '${creator.username}', type: ${type.name}, uuid: '$uuid')";
      case InvitationType.private:
        return ""
          "Invitation(id: $id, garden: '${garden.name}', "
          "creator: '${creator.username}', type: ${type.name}, "
          "usernameOrEmail: '$usernameOrEmail')";
    }
  }
}