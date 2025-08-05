import 'dart:collection';

import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_api.dart';

typedef InvitationTypeEntry = DropdownMenuEntry<InvitationType>;

enum InvitationType {
  open(displayName: "Open"),
  private(displayName: "Private");

  const InvitationType({
    required this.displayName,
  });

  final String displayName;

  static final List<InvitationTypeEntry> entries =
    UnmodifiableListView<InvitationTypeEntry>(
      values.map<InvitationTypeEntry>(
        (InvitationType type) => InvitationTypeEntry(
          value: type,
          label: type.displayName
        )
      ),
    );
}

class Invitation {
  Invitation({
    required this.creator,
    required this.createdDate,
    required this.expiryDate,
    required this.garden,
    required this.id,
    this.invitee,
    required this.type,
    this.uuid
  }) : assert(
    invitee == null || uuid == null,
    "Cannot provide both invitee and uuid"
  ),
  assert(
    (type == InvitationType.open && uuid != null) ||
    (type == InvitationType.private && invitee != null),
    "Open Invitations require uuid. Private Invitations require invitee"
  );

  final AppUser creator;
  final DateTime createdDate;
  final DateTime expiryDate;
  final Garden garden;
  final String id;
  final InvitationType type;
  final AppUser? invitee;
  final String? uuid;

  Invitation.fromJson(
    Map<String, dynamic> json,
    this.creator,
    this.garden,
    this.invitee
  ) :
    createdDate = DateTime.parse(json[GenericField.created]),
    expiryDate = DateTime.parse(json[InvitationField.expiryDate]),
    id = json[GenericField.id] as String,
    type = getInvitationTypeFromString(json[InvitationField.type])!,
    uuid = json[InvitationField.uuid];

  static Map<String, dynamic> emptyMap() {
    return {
      InvitationField.creator: null,
      InvitationField.expiryDate: null,
      InvitationField.garden: null,
      InvitationField.invitee: null,
      InvitationField.type: null,
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
          "invitee: '${invitee!.username}')";
    }
  }
}