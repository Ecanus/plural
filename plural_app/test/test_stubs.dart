import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Test
import 'test_mocks.dart';


void getAsksByGardenIDStub({
  required MockAsksRepository mockAsksRepository,
  required ResultList<RecordModel> asksReturnValue,
  required MockUsersRepository mockUsersRepository,
  required String userID,
  required RecordModel usersReturnValue
}) {
  when(
    () => mockAsksRepository.getList(
      filter: any(named: "filter"), // Use 'any' because of DateTime.now in the filter
      sort: any(named: "sort"))
  ).thenAnswer(
    (_) async => asksReturnValue
  );

  // For Ask creator
  usersRepositoryGetFirstListItemStub(
    mockUsersRepository: mockUsersRepository,
    userID: userID,
    returnValue: usersReturnValue
  );
}
void getCurrentGardenUserGardenRecordsStub({
  required MockUserGardenRecordsRepository mockUserGardenRecordsRepository,
  required String gardenID,
  required ResultList<RecordModel> returnValue,
}) {
  when(
    () => mockUserGardenRecordsRepository.getList(
      expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
      filter: "${UserGardenRecordField.garden} = '$gardenID'",
      sort: "${UserGardenRecordField.user}.${UserField.username}"
    )
  ).thenAnswer(
    (_) async => returnValue
  );
}

void usersRepositoryGetFirstListItemStub({
  required MockUsersRepository mockUsersRepository,
  required String userID,
  required RecordModel returnValue,
}) {
  when(
    () => mockUsersRepository.getFirstListItem(
      filter: "${GenericField.id} = '$userID'"
    )
  ).thenAnswer(
    (_) async => returnValue
  );
}

/// Stub for auth_api.getUserGardenRecordRole()
void getUserGardenRecordRoleStub({
  required MockUserGardenRecordsRepository mockUserGardenRecordsRepository,
  required String userID,
  required String gardenID,
  required ResultList<RecordModel> returnValue,
}) {
  when(
    () => mockUserGardenRecordsRepository.getList(
      filter: ""
        "${UserGardenRecordField.user} = '$userID' && "
        "${UserGardenRecordField.garden} = '$gardenID'",
      sort: "-updated"
    )
  ).thenAnswer(
    (_) async => returnValue
  );
}

void getUserGardenRecordStub({
  required MockUserGardenRecordsRepository mockUserGardenRecordsRepository,
  required String userID,
  required String gardenID,
  required ResultList<RecordModel> userGardenRecordReturnValue,
  required MockUsersRepository mockUsersRepository,
  required String gardenCreatorID,
  required RecordModel gardenCreatorReturnValue,
}) {
  when(
    () => mockUserGardenRecordsRepository.getList(
      expand: "${UserGardenRecordField.user}, ${UserGardenRecordField.garden}",
      filter: ""
        "${UserGardenRecordField.user} = '$userID' && "
        "${UserGardenRecordField.garden} = '$gardenID'",
      sort: "-updated"
    )
  ).thenAnswer(
    (_) async => userGardenRecordReturnValue
  );

  // For Garden Creator
  usersRepositoryGetFirstListItemStub(
    mockUsersRepository: mockUsersRepository,
    userID: gardenCreatorID,
    returnValue: gardenCreatorReturnValue
  );

}

// Stub for GardensRepository.update()
void gardensRepositoryUpdateStub({
  required MockGardensRepository mockGardensRepository,
  required String gardenID,
  required String gardenName,
  required (RecordModel?, Map) returnValue,
}) {
  when(
    () => mockGardensRepository.update(
      id: gardenID,
      body: {
        GardenField.name: gardenName
      }
    )
  ).thenAnswer(
    (_) async => returnValue
  );
}

// Stub for UserGardenRecordsRepository.update()
void userGardenRecordsRepositoryUpdateStub({
  required MockUserGardenRecordsRepository mockUserGardenRecordsRepository,
  required String userGardenRecordID,
  required String userGardenRoleName,
  required (RecordModel?, Map) returnValue,
}) {
  when(
    () => mockUserGardenRecordsRepository.update(
      id: userGardenRecordID,
      body: {
        UserGardenRecordField.role: userGardenRoleName
      }
    )
  ).thenAnswer(
    (_) async => returnValue
  );
}