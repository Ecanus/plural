import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Tests
import '../test_mocks.dart';

void updateStub({
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