import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
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
import '../test_factories.dart';
import '../test_record_models.dart';

void appTestSetupStub({
  required Ask ask,
  required AuthStore authStore,
  required Garden garden,
  required Ask otherAsk,
  required Garden otherGarden,
  required AppUser otherUser,
  required AppUserGardenRecord otherUserGardenRecord,
  required PocketBase pb,
  required Invitation privateInvitation,
  required RecordService recordService,
  required AppUser user,
  required AppUserGardenRecord userGardenRecord,
  required AppUserSettings userSettings,
}) {
  authStoreSetup(authStore: authStore, user: user, pb: pb);
  pocketBaseCollectionsSetup(pb: pb, recordService: recordService);

  authWithPasswordSetup(recordService: recordService);

  getFirstListItemSetup(
    garden: garden,
    otherGarden: otherGarden,
    otherUser: otherUser,
    recordService: recordService,
    user: user,
    userSettings: userSettings);
  getListSetUp(
    ask: ask,
    garden: garden,
    otherAsk: otherAsk,
    otherUser: otherUser,
    otherUserGardenRecord: otherUserGardenRecord,
    privateInvitation: privateInvitation,
    recordService: recordService,
    user: user,
    userGardenRecord: userGardenRecord,);

  unsubscribeSetup(recordService: recordService);
  subscribeSetup(recordService: recordService);
}

void authStoreSetup({
  required AuthStore authStore,
  required AppUser user,
  required PocketBase pb,
}) {
  authStore.save("newToken", getUserRecordModel(user: user));
  when(
    () => pb.authStore
  ).thenReturn(
    authStore
  );
}

void pocketBaseCollectionsSetup({
  required PocketBase pb,
  required RecordService recordService,
}) {
  // pb.collection()
  when(
    () => pb.collection(Collection.asks)
  ).thenAnswer(
    (_) => recordService
  );
  when(
    () => pb.collection(Collection.gardens)
  ).thenAnswer(
    (_) => recordService
  );
  when(
    () => pb.collection(Collection.users)
  ).thenAnswer(
    (_) => recordService
  );
  when(
    () => pb.collection(Collection.userSettings)
  ).thenAnswer(
    (_) => recordService
  );
  when(
    () => pb.collection(Collection.userGardenRecords)
  ).thenAnswer(
    (_) => recordService
  );
  when(
    () => pb.collection(Collection.invitations)
  ).thenAnswer(
    (_) => recordService
  );
}

void authWithPasswordSetup({
  required RecordService recordService,
}) {
  when(
    () => recordService.authWithPassword(any(), any())
  ).thenAnswer(
    (_) async => RecordAuth()
  );
}

void getFirstListItemSetup({
  required Garden garden,
  required Garden otherGarden,
  required AppUser otherUser,
  required RecordService recordService,
  required AppUser user,
  required AppUserSettings userSettings,
}) {
  // RecordService.getFirstListItem() - user
  when(
    () => recordService.getFirstListItem("${GenericField.id} = '${user.id}'")
  ).thenAnswer(
    (_) async => getUserRecordModel(user: user)
  );

  // RecordService.getFirstListItem() - otherUser
  when(
    () => recordService.getFirstListItem("${GenericField.id} = '${otherUser.id}'")
  ).thenAnswer(
    (_) async => getUserRecordModel(user: otherUser)
  );

  // RecordService.getFirstListItem() - garden.creator
  when(
    () => recordService.getFirstListItem("${GenericField.id} = '${garden.creator.id}'")
  ).thenAnswer(
    (_) async => getUserRecordModel(user: garden.creator)
  );

  // RecordService.getFirstListItem() - otherGarden.creator
  when(
    () => recordService.getFirstListItem("${GenericField.id} = '${otherGarden.creator.id}'")
  ).thenAnswer(
    (_) async => getUserRecordModel(user: otherGarden.creator)
  );

  // RecordService.getFirstListItem() - userSettings
  when(
    () => recordService.getFirstListItem(
      "${UserSettingsField.user} = '${user.id}'")
  ).thenAnswer(
    (_) async => getUserSettingsRecordModel(userSettings: userSettings)
  );

  // RecordService.getFirstListItem() - garden
  when(
    () => recordService.getFirstListItem(
      "${GenericField.id} = '${garden.id}'")
  ).thenAnswer(
    (_) async => getGardenRecordModel(garden: garden)
  );
}

void getListSetUp({
  required Ask ask,
  required Garden garden,
  required Ask otherAsk,
  required AppUser otherUser,
  required AppUserGardenRecord otherUserGardenRecord,
  required Invitation privateInvitation,
  required RecordService recordService,
  required AppUser user,
  required AppUserGardenRecord userGardenRecord,
}) {
  // RecordService.getList() - getCurrentGardenUserGardenRecords()
  when(
    () => recordService.getList(
      expand: UserGardenRecordField.user,
      filter: "${UserGardenRecordField.garden} = '${garden.id}'",
      sort: "${UserGardenRecordField.user}.${UserField.username}"
    )
  ).thenAnswer(
    (_) async => ResultList<RecordModel>(
      items: [
        getUserGardenRecordRecordModel(
          userGardenRecord: userGardenRecord,
          expandFields: [
            UserGardenRecordField.user,
            UserGardenRecordField.garden
          ]
        ),
        getUserGardenRecordRecordModel(
          userGardenRecord: otherUserGardenRecord,
          expandFields: [
            UserGardenRecordField.user,
            UserGardenRecordField.garden
          ]
        ),
      ]
    )
  );

  // RecordService.getList() - getUserGardenRecordsByUserID()
  when(
    () => recordService.getList(
      expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
      filter: "${UserGardenRecordField.user} = '${user.id}'",
      sort: "${UserGardenRecordField.garden}.${GardenField.name}",
    )
  ).thenAnswer(
    (_) async => ResultList<RecordModel>(
      items: [getUserGardenRecordRecordModel(
        userGardenRecord: userGardenRecord,
        expandFields: [
          UserGardenRecordField.user,
          UserGardenRecordField.garden
      ])]
    )
  );

  // RecordService.getList() - getUserGardenRecord()
  when(
    () => recordService.getList(
      expand: any(named: "expand"),
      filter: ""
        "${UserGardenRecordField.user} = '${user.id}' && "
        "${UserGardenRecordField.garden} = '${garden.id}'",
      sort: "-updated",
    )
  ).thenAnswer(
    (_) async => ResultList<RecordModel>(
      items: [
        getUserGardenRecordRecordModel(
          userGardenRecord: userGardenRecord,
          expandFields: [
            UserGardenRecordField.user,
            UserGardenRecordField.garden
          ],
        ),
      ]
    )
  );

  // RecordService.getList() - getGardensByUser(excludeCurrentGarden: false)
  when(
    () => recordService.getList(
      expand: UserGardenRecordField.garden,
      filter: "${UserGardenRecordField.user} = '${user.id}'",
      sort: "garden.name",
    )
  ).thenAnswer(
    (_) async => ResultList<RecordModel>(
      items: [
        getUserGardenRecordRecordModel(
          userGardenRecord: AppUserGardenRecordFactory(
            garden: garden,
            user: user,
          ),
          expandFields: [UserGardenRecordField.garden]
      )]
    )
  );

  // RecordService.getList() - getAsksByGardenID
  when(
    () => recordService.getList(
      expand: any(named: "expand"),
      filter: any(named: "filter"), // use any() because internal nowString is down to the second (inconsistent to recreate)
      sort: "${AskField.deadlineDate},${GenericField.created}",
    )
  ).thenAnswer(
    (_) async => ResultList<RecordModel>(
      items: [
        getAskRecordModel(ask: ask),
        getAskRecordModel(ask: otherAsk)
      ]
    )
  );

  // recordService.getList() - getAsksForListedAsksDialog()
  when(
    () => recordService.getList(
      expand: any(named: "expand"),
      filter: any(named: "filter"), // Use any(). Copy pasting the filter string doesn't seem to work
      sort: GenericField.created,
    )
  ).thenAnswer(
    (_) async => ResultList<RecordModel>(items: [getAskRecordModel(ask: ask)]
    )
  );

  // recordService.getList() - getInvitationsByInvitee()
  when(
    () => recordService.getList(
      expand: ""
        "${InvitationField.creator}, ${InvitationField.invitee}, ${InvitationField.garden}",
      filter: any(named: "filter"), // use any() because of DateTime.now()
      sort: "${GenericField.created}, ${InvitationField.expiryDate}",
    )
  ).thenAnswer(
    (_) async => ResultList<RecordModel>(items: [
      getPrivateInvitationRecordModel(
        invitation: privateInvitation,
        expandFields: [
          InvitationField.creator,
          InvitationField.garden,
          InvitationField.invitee,
        ]
      )
    ]
    )
  );

  // recordService.getList() - getCurrentGardenInvitations()
  when(
    () => recordService.getList(
      expand: "${InvitationField.creator}, ${InvitationField.invitee}",
      filter: any(named: "filter"), // use any() because of DateTime.now() usage
      sort: GenericField.created
    )
  ).thenAnswer(
    (_) async => ResultList<RecordModel>(items: [
      getPrivateInvitationRecordModel(
        invitation: InvitationFactory(
          creator: user,
          garden: garden,
          type: InvitationType.private,
        ),
        expandFields: [
          InvitationField.creator,
          InvitationField.invitee,
        ]
      )
    ]
    )
  );
}

void unsubscribeSetup({
  required RecordService recordService,
}) {
  when(
    () => recordService.unsubscribe()
  ).thenAnswer(
    (_) async => () async {}
  );
}

void subscribeSetup({
  required RecordService recordService,
}) {
  when(
    () => recordService.subscribe(any(), any())
  ).thenAnswer(
    (_) async => () async {}
  );
}