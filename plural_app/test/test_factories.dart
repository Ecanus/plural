import 'package:plural_app/src/utils/exceptions.dart' as exceptions;

import 'package:pocketbase/pocketbase.dart';
import 'package:uuid/uuid.dart';

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