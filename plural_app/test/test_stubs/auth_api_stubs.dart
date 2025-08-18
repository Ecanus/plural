import '../test_stubs/users_repository_stubs.dart' as users_repository;

import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Tests
import '../test_mocks.dart';


void getCurrentGardenUserGardenRecordsStub({
  required MockUserGardenRecordsRepository mockUserGardenRecordsRepository,
  required String gardenID,
  required ResultList<RecordModel> returnValue,
}) {
  when(
    () => mockUserGardenRecordsRepository.getList(
      expand: UserGardenRecordField.user,
      filter: "${UserGardenRecordField.garden} = '$gardenID'",
      sort: "${UserGardenRecordField.user}.${UserField.username}"
    )
  ).thenAnswer(
    (_) async => returnValue
  );
}

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
  users_repository.getFirstListItemStub(
    mockUsersRepository: mockUsersRepository,
    userID: gardenCreatorID,
    returnValue: gardenCreatorReturnValue
  );
}