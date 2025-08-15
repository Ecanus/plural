import 'package:plural_app/src/utils/exceptions.dart' as exceptions;

import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:uuid/uuid.dart';

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

class TestContext {
  late Ask ask;
  late Garden garden;
  late Invitation openInvitation;
  late Invitation privateInvitation;
  late AppUser user;
  late AppUser otherUser;
  late AppUserGardenRecord userGardenRecord;
  late AppUserSettings userSettings;
  late ClientException clientException;

  TestContext(String x) {
    user = AppUser(
      firstName: "MyFirstName",
      id: "TESTUSER1",
      lastName: "MyLastName",
      username: "testuser"
    );

    otherUser = AppUser(
      firstName: "otherUserFirstName",
      id: "TESTOTHERUSER1",
      lastName: "otherUserLastName",
      username: "otherUser"
    );

    garden = Garden(
      creator: user,
      doDocument: "Test Do Document in TestContext",
      doDocumentEditDate: DateTime(2000, 1, 31),
      id: "TESTGARDEN1",
      name: "Petunia"
    );

    openInvitation = Invitation(
      creator: user,
      createdDate: DateTime(2025, 8, 15),
      expiryDate: DateTime(2050, 8, 15),
      garden: garden,
      id: "TESTINVITATIONOPEN",
      invitee: null,
      type: InvitationType.open,
      uuid: "UUUU-II-D-DDDDD",
    );

    privateInvitation = Invitation(
      creator: user,
      createdDate: DateTime(2025, 8, 15),
      expiryDate: DateTime(2050, 8, 15),
      garden: garden,
      id: "TESTINVITATIONPRIVATE",
      invitee: otherUser,
      type: InvitationType.private,
      uuid: null,
    );

    userGardenRecord = AppUserGardenRecord(
      garden: garden,
      doDocumentReadDate: DateTime(2000, 1, 31),
      id: "TESTGARDENRECORD1",
      role: AppUserGardenRole.member,
      user: user,
    );

    userSettings = AppUserSettings(
      defaultCurrency: "GHS",
      defaultInstructions: "The default instructions",
      gardenTimelineDisplayCount: 3,
      id: "USERSETTINGS1",
      user: user
    );

    ask = Ask(
      id: "TESTASK1",
      boon: 15,
      creator: user,
      creationDate: DateTime.parse("1995-06-13"),
      currency: "GHS",
      description: "Test description of TESTASK1",
      deadlineDate: DateTime.parse("1995-07-24"),
      instructions: "Test instructions of TESTASK1",
      targetMetDate: null,
      targetSum: 160,
      type: AskType.monetary,
    );

    // clientException = ClientException(
    //   originalError: "Original error message",
    //   response: {
    //     exceptions.dataKey: {
    //       "FieldKey": {
    //         exceptions.messageKey: "The inner map message of signup()"
    //       }
    //     }
    //   },
    // );
  }

  // Ask getNewAsk({
  //   required String id,
  //   int boon = 5,
  //   DateTime? creationDate,
  //   String currency = "GHS",
  //   String? description,
  //   DateTime? deadlineDate,
  //   String? instructions,
  //   DateTime? targetMetDate,
  //   int targetSum = 100
  // }) {
  //   return Ask(
  //     id: id,
  //     boon: boon,
  //     creator: user,
  //     creationDate: creationDate ?? DateTime.parse("1995-06-13"),
  //     currency: "GHS",
  //     description: description ?? "Test description of $id",
  //     deadlineDate: deadlineDate ?? DateTime.parse("1995-07-24"),
  //     instructions: instructions ?? "Test instructions of $id",
  //     targetMetDate: targetMetDate,
  //     targetSum: targetSum,
  //     type: AskType.monetary,
  //   );
  // }

  // RecordModel getGardenRecordModel({
  //   String? creatorID,
  //   String? doDocument,
  //   String? doDocumentEditDate,
  //   String? id,
  //   String? name,
  // }) {
  //   return RecordModel({
  //     "id": id ?? garden.id,
  //     "created": "1990-10-16",
  //     "collectionName": Collection.gardens,
  //     GardenField.creator: creatorID ?? user.id,
  //     GardenField.doDocument: doDocument ?? "Do Document",
  //     GardenField.doDocumentEditDate: doDocumentEditDate ?? "2020-11-29",
  //     GardenField.name: name ?? garden.name,
  //   });
  // }

  RecordModel getOpenInvitationRecordModel({
    String? id,
    String? creatorID,
    String? expiryDate,
    String? gardenID,
    List<String> expand = const [],
  }) {
    Map<String, dynamic> map = {};

    addExpandFields(expand, map);

    return RecordModel({
      "id": id ?? openInvitation.id,
      "created": DateFormat(Formats.dateYMMdd).format(openInvitation.createdDate),
      "collectionName": Collection.invitations,
      InvitationField.creator: creatorID ?? user.id,
      InvitationField.expiryDate: expiryDate ??
        DateFormat(Formats.dateYMMdd).format(openInvitation.expiryDate),
      InvitationField.garden: gardenID ?? garden.id,
      InvitationField.type: InvitationType.open.name,
      InvitationField.uuid: "UUUU-II-D-DDDDD",
      "expand": map,
    });
  }

  // RecordModel getPrivateInvitationRecordModel({
  //   String? id,
  //   String? creatorID,
  //   String? expiryDate,
  //   String? gardenID,
  //   String? otherUserID,
  //   List<String> expand = const [],
  // }) {
  //   Map<String, dynamic> map = {};

  //   addExpandFields(expand, map);

  //   return RecordModel({
  //     "id": id ?? privateInvitation.id,
  //     "created": DateFormat(Formats.dateYMMdd).format(privateInvitation.createdDate),
  //     "collectionName": Collection.invitations,
  //     InvitationField.creator: creatorID ?? user.id,
  //     InvitationField.expiryDate: expiryDate ??
  //       DateFormat(Formats.dateYMMdd).format(privateInvitation.expiryDate),
  //     InvitationField.garden: gardenID ?? garden.id,
  //     InvitationField.type: InvitationType.private.name,
  //     InvitationField.invitee: otherUserID ?? otherUser.id,
  //     "expand": map,
  //   });
  // }


  // RecordModel getUserGardenRecordRecordModel({
  //   String? recordID,
  //   AppUserGardenRole role = AppUserGardenRole.member,
  //   List<String> expand = const []
  // }) {
  //   Map<String, dynamic> map = {};

  //   addExpandFields(expand, map);

  //   return RecordModel.fromJson({
  //     GenericField.id: recordID ?? userGardenRecord.id,
  //     GenericField.created: "1999-10-08",
  //     UserGardenRecordField.user: user.id,
  //     UserGardenRecordField.garden: garden.id,
  //     UserGardenRecordField.doDocumentReadDate: "2000-01-31",
  //     UserGardenRecordField.role: role.name,
  //     "expand": map
  //   });
  // }

  // RecordModel getUserRecordModel({
  //   String? id,
  //   String? firstName,
  //   String? lastName,
  //   String? username,
  // }) {
  //   return RecordModel({
  //     "id": id ?? user.id,
  //     "created": "1992-12-23",
  //     "collectionName": Collection.users,
  //     UserField.firstName: firstName ?? user.firstName,
  //     UserField.lastName: lastName ?? user.lastName,
  //     UserField.username: username ?? user.username,
  //   });
  // }

  RecordModel getUserSettingsRecordModel({
    String? defaultCurrency,
    String? defaultInstructions,
    int? gardenTimelineDisplayCount,
    String? userID,
  }) {
    return RecordModel({
      "id": userSettings.id,
      "created": "2001-01-03",
      "collectionName": Collection.userSettings,
      UserSettingsField.defaultCurrency: defaultCurrency ?? "GHS",
      UserSettingsField.defaultInstructions:
        defaultInstructions ?? "UserSettings record instructions",
      UserSettingsField.gardenTimelineDisplayCount:
        gardenTimelineDisplayCount ?? userSettings.gardenTimelineDisplayCount,
      UserSettingsField.user: userID ?? user.id,
    });
  }

  void addExpandFields(List<String> expandFields, Map<String, dynamic> map) {
    if (expandFields.contains(UserGardenRecordField.user)) {
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
      map[UserGardenRecordField.garden] = {
        GenericField.id: garden.id,
        GenericField.created: "1993-11-11",
        GardenField.creator: user.id,
        GardenField.doDocument: "Expaned Do Document",
        GardenField.doDocumentEditDate: "2000-10-28",
        GardenField.name: garden.name,
      };
    }

    if (expandFields.contains(InvitationField.creator)) {
      map[InvitationField.creator] = {
        GenericField.id: user.id,
        GenericField.created: "1992-12-23",
        UserField.firstName: user.firstName,
        UserField.lastName: user.lastName,
        UserField.username: user.username
      };
    }

    if (expandFields.contains(InvitationField.invitee)) {
      map[InvitationField.invitee] = {
        GenericField.id: otherUser.id,
        GenericField.created: "1992-12-23",
        UserField.firstName: otherUser.firstName,
        UserField.lastName: otherUser.lastName,
        UserField.username: otherUser.username
      };
    }
  }

  ClientException getClientException({
    String originalError = "Original error message",
    String fieldKey = "FieldKey",
    String message = "The inner map message of signup()"
  }) {
    return ClientException(
      originalError: originalError,
      response: {
        exceptions.dataKey: {
          fieldKey: {
            exceptions.messageKey: message
          }
        }
      },
    );
  }
}

class ClientExceptionFactory extends ClientException {
  static final Map<String, ClientExceptionFactory> _cache =
    <String, ClientExceptionFactory>{};

  factory ClientExceptionFactory.empty({
    String? key,
  }) {

    key = key ?? "client-exception-${_cache.length}";

    return _cache.putIfAbsent(key, () => ClientExceptionFactory._internal(
      isAbort: false,
      originalError: "",
      response: {},
      statusCode: 0,
      url: null
    ));
  }

  factory ClientExceptionFactory({
    String exceptionMessage = "",
    required String fieldName,
    String? key,
    Uri? url,
  }) {

    key = key ?? "client-exception-${_cache.length}";

    return _cache.putIfAbsent(key, () => ClientExceptionFactory._internal(
      isAbort: false,
      originalError: "",
      response: {
        exceptions.dataKey: {
          fieldName: {
            exceptions.messageKey: exceptionMessage,
          }
        }
      },
      statusCode: 0,
      url: url
    ));
  }

  ClientExceptionFactory._internal({
    super.isAbort,
    super.originalError,
    super.response,
    super.statusCode,
    super.url,
  });
}

class AppUserFactory extends AppUser {
  static final Map<String, AppUserFactory> _cache = <String, AppUserFactory>{};

  factory AppUserFactory({
    String? firstName,
    String? id,
    String? lastName,
    String? username,
  }) {

    id = id ?? "user-${_cache.length}";

    return _cache.putIfAbsent(
      id, () => AppUserFactory._internal(
        firstName: firstName ?? "Yaa",
        id: id!,
        lastName: lastName ?? "Asantewaa",
        username: username ?? "queenMother",
      )
    );
  }

  factory AppUserFactory.uncached({
    String? firstName,
    required String id,
    String? lastName,
    String? username,
  }) {
    return AppUserFactory._internal(
      firstName: firstName ?? "Yaa",
      id: id,
      lastName: lastName ?? "Asantewaa",
      username: username ?? "queenMother",
    );
  }

  AppUserFactory._internal({
    required super.firstName,
    required super.id,
    required super.lastName,
    required super.username,
  });
}

class AppUserGardenRecordFactory extends AppUserGardenRecord {
  static final Map<String, AppUserGardenRecordFactory> _cache =
    <String, AppUserGardenRecordFactory>{};

  factory AppUserGardenRecordFactory({
    DateTime? doDocumentReadDate,
    Garden? garden,
    String? id,
    AppUserGardenRole role = AppUserGardenRole.member,
    AppUser? user,
  }) {

    id = id ?? "user-garden-record-${_cache.length}";

    return _cache.putIfAbsent(
      id,
      () => AppUserGardenRecordFactory._internal(
        doDocumentReadDate: doDocumentReadDate ?? DateTime(2021, 08, 08),
        garden: garden ?? GardenFactory(),
        user: user ?? AppUserFactory(),
        id: id!,
        role: role
      )
    );
  }

  factory AppUserGardenRecordFactory.uncached({
    DateTime? doDocumentReadDate,
    Garden? garden,
    required String id,
    AppUserGardenRole role = AppUserGardenRole.member,
    AppUser? user,
  }) {
    return AppUserGardenRecordFactory._internal(
      doDocumentReadDate: doDocumentReadDate ?? DateTime(2021, 08, 08),
      garden: garden ?? GardenFactory(),
      user: user ?? AppUserFactory(),
      id: id,
      role: role
    );
  }

  AppUserGardenRecordFactory._internal({
    required super.doDocumentReadDate,
    required super.garden,
    required super.id,
    required super.role,
    required super.user
  });
}

class AppUserSettingsFactory extends AppUserSettings {
  static final Map<String, AppUserSettingsFactory> _cache =
    <String, AppUserSettingsFactory>{};

  factory AppUserSettingsFactory({
    String? defaultCurrency,
    String? defaultInstructions,
    int? gardenTimelineDisplayCount,
    String? id,
    AppUser? user,
  }) {

    id = id ?? "user-settings-${_cache.length}";

    return _cache.putIfAbsent(
      id,
      () => AppUserSettingsFactory._internal(
        defaultCurrency: defaultCurrency ?? "GHS",
        defaultInstructions: defaultInstructions ?? "Test default instructions",
        gardenTimelineDisplayCount: gardenTimelineDisplayCount ?? 3,
        id: id!,
        user: user ?? AppUserFactory(),
      )
    );
  }

  factory AppUserSettingsFactory.uncached({
    String? defaultCurrency,
    String? defaultInstructions,
    int? gardenTimelineDisplayCount,
    required String id,
    AppUser? user,
  }) {
    return AppUserSettingsFactory._internal(
      defaultCurrency: defaultCurrency ?? "GHS",
      defaultInstructions: defaultInstructions ?? "Test default instructions",
      gardenTimelineDisplayCount: gardenTimelineDisplayCount ?? 3,
      id: id,
      user: user ?? AppUserFactory(),
    );
  }

  AppUserSettingsFactory._internal({
    required super.defaultCurrency,
    required super.defaultInstructions,
    required super.gardenTimelineDisplayCount,
    required super.id,
    required super.user
  });
}

class AskFactory extends Ask {
  static final Map<String, AskFactory> _cache =
    <String, AskFactory>{};

  factory AskFactory({
    int? boon,
    DateTime? creationDate,
    AppUser? creator,
    String? currency,
    DateTime? deadlineDate,
    String? description,
    String? id,
    String? instructions,
    DateTime? targetMetDate,
    int? targetSum,
  }) {

    id = id ?? "ask-${_cache.length}";

    return _cache.putIfAbsent(
      id,
      () => AskFactory._internal(
        boon: boon ?? 5,
        creator: creator ?? AppUserFactory(),
        creationDate: creationDate ?? DateTime.now().add(Duration(days: -1)), // yesterday
        currency: currency ?? "GHS",
        deadlineDate: deadlineDate ?? DateTime.now().add(Duration(days: 7)), // in a week
        description: description ?? "Test description for $id",
        id: id!,
        instructions: instructions ?? "Test instructions for $id",
        targetMetDate: targetMetDate,
        targetSum: targetSum ?? 50,
        type: AskType.monetary
      )
    );
  }

  AskFactory._internal({
    required super.boon,
    required super.creator,
    required super.creationDate,
    required super.currency,
    required super.deadlineDate,
    required super.description,
    required super.id,
    required super.instructions,
    super.targetMetDate,
    required super.targetSum,
    required super.type
  });
}

class GardenFactory extends Garden {
  static final Map<String, GardenFactory> _cache = <String, GardenFactory>{};

  factory GardenFactory({
    AppUser? creator,
    String? doDocument,
    DateTime? doDocumentEditDate,
    String? id,
    String? name,
  }) {

    id = id ?? "garden-${_cache.length}";

    return _cache.putIfAbsent(
      "test-garden-factory-${_cache.length}", () => GardenFactory._internal(
        creator: creator ?? AppUserFactory(),
        doDocument: doDocument ?? "Do Document Test Value",
        doDocumentEditDate: doDocumentEditDate ?? DateTime(2020, 08, 08),
        id: id!,
        name: name ?? "Garden #${_cache.length}"
      )
    );
  }

  factory GardenFactory.uncached({
    AppUser? creator,
    String? doDocument,
    DateTime? doDocumentEditDate,
    required String id,
    String? name,
  }) {
    return GardenFactory._internal(
      creator: creator ?? AppUserFactory(),
      doDocument: doDocument ?? "Do Document Test Value",
      doDocumentEditDate: doDocumentEditDate ?? DateTime(2020, 08, 08),
      id: id,
      name: name ?? "Garden #${_cache.length}"
    );
  }

  GardenFactory._internal({
    required super.creator,
    required super.doDocument,
    required super.doDocumentEditDate,
    required super.id,
    required super.name
  });
}

class InvitationFactory extends Invitation {
  static final Map<String, InvitationFactory> _cache = <String, InvitationFactory>{};

  factory InvitationFactory({
    DateTime? createdDate,
    AppUser? creator,
    DateTime? expiryDate,
    Garden? garden,
    String? id,
    AppUser? invitee,
    required InvitationType type,
    String? uuid,
  }) {
    id = id ?? "invitation-${_cache.length}";

    return _cache.putIfAbsent(
      id,
      () => InvitationFactory._internal(
        createdDate: createdDate ?? DateTime(2025, 8, 14),
        creator: creator ?? AppUserFactory(),
        expiryDate: expiryDate ?? DateTime.now().add(Duration(days: 7)), // a week from now
        garden: garden ?? GardenFactory(),
        id: id!,
        invitee: type == InvitationType.private ? (invitee ?? AppUserFactory()) : null,
        type: type,
        uuid: type == InvitationType.open ? (uuid ?? Uuid().v1()) : null,
      )
    );
  }

  factory InvitationFactory.uncached({
    DateTime? createdDate,
    AppUser? creator,
    DateTime? expiryDate,
    Garden? garden,
    required String id,
    AppUser? invitee,
    required InvitationType type,
    String? uuid,
  }) {
    return InvitationFactory._internal(
      createdDate: createdDate ?? DateTime(2025, 8, 14),
      creator: creator ?? AppUserFactory(),
      expiryDate: expiryDate ?? DateTime.now().add(Duration(days: 7)), // a week from now
      garden: garden ?? GardenFactory(),
      id: id,
      invitee: type == InvitationType.private ? (invitee ?? AppUserFactory()) : null,
      type: type,
      uuid: type == InvitationType.open ? (uuid ?? Uuid().v1()) : null,
    );
  }

  factory InvitationFactory.testAssert({
    DateTime? createdDate,
    AppUser? creator,
    DateTime? expiryDate,
    Garden? garden,
    required String id,
    AppUser? invitee,
    required InvitationType type,
    String? uuid,
  }) {
    return InvitationFactory._internal(
      createdDate: createdDate ?? DateTime(2025, 8, 14),
      creator: creator ?? AppUserFactory(),
      expiryDate: expiryDate ?? DateTime.now().add(Duration(days: 7)), // a week from now
      garden: garden ?? GardenFactory(),
      id: id,
      invitee: invitee,
      type: type,
      uuid: uuid,
    );
  }

  InvitationFactory._internal({
    required super.createdDate,
    required super.creator,
    required super.expiryDate,
    required super.garden,
    required super.id,
    super.invitee,
    required super.type,
    super.uuid
  });
}

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
        GardenField.doDocument: "Expaned Do Document",
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