import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Invitations
import 'package:plural_app/src/features/invitations/domain/invitation.dart';

// Tests
import 'test_factories.dart';

RecordModel getAskRecordModel({
  Ask? ask,
  List<String> sponsors = const []
}) {
  ask = ask ?? AskFactory();

  return RecordModel({
    "id": ask.id,
    "created": DateFormat(Formats.dateYMMdd).format(ask.creationDate),
    "collectionName": Collection.asks,
    AskField.boon: ask.boon,
    AskField.creator: ask.creator.id,
    AskField.currency: ask.currency,
    AskField.deadlineDate: DateFormat(Formats.dateYMMdd).format(ask.deadlineDate),
    AskField.description: ask.description,
    AskField.instructions: ask.instructions,
    AskField.sponsors: sponsors,
    AskField.targetSum: ask.targetSum,
    AskField.targetMetDate:
      ask.targetMetDate == null ?
        "" :
        DateFormat(Formats.dateYMMdd).format(ask.targetMetDate!),
    AskField.type: "monetary"
  });
}

RecordModel getGardenRecordModel({
  Garden? garden,
}) {
  garden = garden ?? GardenFactory();

  return RecordModel({
    "id": garden.id,
    "created": "1990-10-16",
    "collectionName": Collection.gardens,
    GardenField.creator: garden.creator.id,
    GardenField.doDocument: garden.doDocument,
    GardenField.doDocumentEditDate:
      DateFormat(Formats.dateYMMddHHm).format(garden.doDocumentEditDate),
    GardenField.name: garden.name,
  });
}

  RecordModel getOpenInvitationRecordModel({
    Invitation? invitation,
    List<String> expandFields = const [],
  }) {
    final type = InvitationType.open;
    Map<String, dynamic> map = {};

    invitation = invitation ?? InvitationFactory(type: type);

    addExpandFields(
      expandFields, map,
      creator: invitation.creator,
      garden: invitation.garden,
    );

    return RecordModel({
      "id": invitation.id,
      "created": DateFormat(Formats.dateYMMdd).format(invitation.createdDate),
      "collectionName": Collection.invitations,
      InvitationField.creator: invitation.creator.id,
      InvitationField.expiryDate:
        DateFormat(Formats.dateYMMdd).format(invitation.expiryDate),
      InvitationField.garden: invitation.garden.id,
      InvitationField.type: type.name,
      InvitationField.uuid: invitation.uuid,
      "expand": map,
    });
  }

RecordModel getPrivateInvitationRecordModel({
  Invitation? invitation,
  List<String> expandFields = const [],
}) {
  final type = InvitationType.private;
  Map<String, dynamic> map = {};

  invitation = invitation ?? InvitationFactory(type: type);

  addExpandFields(
    expandFields, map,
    creator: invitation.creator,
    garden: invitation.garden,
    invitee: invitation.invitee,
  );

  return RecordModel({
    "id": invitation.id,
    "created": DateFormat(Formats.dateYMMdd).format(invitation.createdDate),
    "collectionName": Collection.invitations,
    InvitationField.creator: invitation.creator.id,
    InvitationField.expiryDate:
      DateFormat(Formats.dateYMMdd).format(invitation.expiryDate),
    InvitationField.garden: invitation.garden.id,
    InvitationField.type: type.name,
    InvitationField.invitee: invitation.invitee!.id,
    "expand": map,
  });
}

RecordModel getUserGardenRecordRecordModel({
  AppUserGardenRecord? userGardenRecord,
  List<String> expandFields = const [],
}) {
  Map<String, dynamic> map = {};

  userGardenRecord = userGardenRecord ?? AppUserGardenRecordFactory();
  addExpandFields(
    expandFields, map,
    user: userGardenRecord.user,
    garden: userGardenRecord.garden,
  );

  return RecordModel.fromJson({
    GenericField.id: userGardenRecord.id,
    GenericField.created: "1999-10-08",
    UserGardenRecordField.user: userGardenRecord.user.id,
    UserGardenRecordField.garden: userGardenRecord.garden.id,
    UserGardenRecordField.doDocumentReadDate:
      DateFormat(Formats.dateYMMdd).format(userGardenRecord.doDocumentReadDate),
    UserGardenRecordField.role: userGardenRecord.role.name,
    "expand": map
  });
}

RecordModel getUserRecordModel({
  AppUser? user,
}) {
  user = user ?? AppUserFactory();

  return RecordModel({
    "id": user.id,
    "created": "1992-12-23",
    "collectionName": Collection.users,
    UserField.firstName: user.firstName,
    UserField.lastName: user.lastName,
    UserField.username: user.username,
  });
}

RecordModel getUserSettingsRecordModel({
  AppUserSettings? userSettings,
  List<String> expandFields = const [],
}) {
  Map<String, dynamic> map = {};

  userSettings = userSettings ?? AppUserSettingsFactory();

  addExpandFields(
    expandFields, map,
    user: userSettings.user,
  );

  return RecordModel.fromJson({
    GenericField.id: userSettings.id,
    GenericField.created: "1999-10-08",
    "collectionName": Collection.userSettings,
    UserSettingsField.defaultCurrency: userSettings.defaultCurrency,
    UserSettingsField.defaultInstructions: userSettings.defaultInstructions,
    UserSettingsField.gardenTimelineDisplayCount:
      userSettings.gardenTimelineDisplayCount,
    UserSettingsField.user: userSettings.user.id,
    "expand": map
  });
}

void addExpandFields(
  List<String> expandFields,
  Map<String, dynamic> map, {
  AppUser? user,
  AppUser? creator,
  AppUser? invitee,
  Garden? garden,
}) {
  if (expandFields.contains(UserGardenRecordField.user)) {
    user = user ?? AppUserFactory();

    map[UserGardenRecordField.user] = {
      GenericField.id: user.id,
      GenericField.created: "1992-12-23",
      UserField.firstName: user.firstName,
      UserField.lastName: user.lastName,
      UserField.username: user.username
    };
  }

  if (
      expandFields.contains(UserGardenRecordField.garden) ||
      expandFields.contains(InvitationField.garden)
    ) {
      user = user ?? AppUserFactory();
      garden = garden ?? GardenFactory();

      map[UserGardenRecordField.garden] = {
        GenericField.id: garden.id,
        GenericField.created: "1993-11-11",
        GardenField.creator: garden.creator.id,
        GardenField.doDocument: "Expand Do Document",
        GardenField.doDocumentEditDate: "2000-10-28",
        GardenField.name: garden.name,
      };
  }

  if (expandFields.contains(InvitationField.creator)) {
    creator = creator ?? AppUserFactory();

    map[InvitationField.creator] = {
      GenericField.id: creator.id,
      GenericField.created: "1992-12-23",
      UserField.firstName: creator.firstName,
      UserField.lastName: creator.lastName,
      UserField.username: creator.username
    };
  }

  if (expandFields.contains(InvitationField.invitee)) {
    invitee = invitee ?? AppUserFactory();

    map[InvitationField.invitee] = {
      GenericField.id: invitee.id,
      GenericField.created: "1992-12-23",
      UserField.firstName: invitee.firstName,
      UserField.lastName: invitee.lastName,
      UserField.username: invitee.username
    };
  }
}