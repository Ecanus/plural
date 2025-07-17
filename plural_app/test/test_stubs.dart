import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Test
import 'test_mocks.dart';


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

void getFirstListItemStub({
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
  getFirstListItemStub(
    mockUsersRepository: mockUsersRepository,
    userID: gardenCreatorID,
    returnValue: gardenCreatorReturnValue
  );

}

// Stub for GardensRepository.update()
void updateGardenStub({
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
void updateUserGardenRecordStub({
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