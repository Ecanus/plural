import '../test_stubs/users_repository_stubs.dart' as users_repository;

import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Tests
import '../test_mocks.dart';

void getAsksByGardenIDStub({
  required MockAsksRepository mockAsksRepository,
  String? asksFilter,
  required ResultList<RecordModel> asksReturnValue,
  required MockUsersRepository mockUsersRepository,
  required String userID,
  required RecordModel usersReturnValue
}) {
  when(
    () => mockAsksRepository.getList(
      filter: asksFilter ?? any(named: "filter"), // 'any' is for filters using DateTime.now
      sort: any(named: "sort"))
  ).thenAnswer(
    (_) async => asksReturnValue
  );

  // For Ask creator
  users_repository.getFirstListItemStub(
    mockUsersRepository: mockUsersRepository,
    userID: userID,
    returnValue: usersReturnValue
  );
}

void getAsksByUserIDStub({
  required MockAsksRepository mockAsksRepository,
  String asksFilter = "",
  String asksSort = "",
  required String gardenID,
  required ResultList<RecordModel> asksReturnValue,
  required MockUsersRepository mockUsersRepository,
  required String userID,
  required RecordModel usersReturnValue
}) {
  when(
    () => mockAsksRepository.getList(
      filter: ""
        "${AskField.creator} = '$userID' && "
        "${AskField.garden} = '$gardenID' $asksFilter".trim(),
      sort: asksSort,
    )
  ).thenAnswer(
    (_) async => asksReturnValue
  );

  // For Ask creator
  users_repository.getFirstListItemStub(
    mockUsersRepository: mockUsersRepository,
    userID: userID,
    returnValue: usersReturnValue
  );
}