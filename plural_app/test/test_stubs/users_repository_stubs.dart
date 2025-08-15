import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Test
import '../test_mocks.dart';

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