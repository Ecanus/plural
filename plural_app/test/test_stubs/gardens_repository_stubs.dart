import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';

// Tests
import '../test_mocks.dart';

void updateStub({
  required MockGardensRepository mockGardensRepository,
  required String gardenID,
  required String gardenDoDocument,
  required DateTime gardenDoDocumentEditDate,
  required String gardenName,
  required (RecordModel?, Map) returnValue,
}) {
  when(
    () => mockGardensRepository.update(
      id: gardenID,
      body: {
        GardenField.doDocument: gardenDoDocument,
        GardenField.doDocumentEditDate:
          DateFormat(Formats.dateYMMddHHm).format(gardenDoDocumentEditDate),
        GardenField.name: gardenName,
      }
    )
  ).thenAnswer(
    (_) async => returnValue
  );
}