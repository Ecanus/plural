import 'package:test/test.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("AppUserGardenRecord test", () {
    test("constructor", () {
      final tc = TestContext();

      expect(tc.userGardenRecord.id == "TESTGARDENRECORD1", true);
      expect(tc.userGardenRecord.user == tc.user, true);
      expect(tc.userGardenRecord.garden == tc.garden, true);
    });
  });
}