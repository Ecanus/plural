import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_repository.dart';

// Tests
import '../../../test_context.dart';
import '../../../test_mocks.dart';

void main() {
  group("InvitationsRepository", () {
    test("create", () async {
      final tc = TestContext();
      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final invitationsRepository = InvitationsRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(Collection.invitations)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.create(), No Exception
      when(
        () => recordService.create(body: any(named: "body"))
      ).thenAnswer(
        (_) async => tc.getOpenInvitationRecordModel()
      );

      // Check record is not null, and errorsMap is empty
      final (record1, errorsMap1) = await invitationsRepository.create(body: {});
      expect(record1, isNotNull);
      expect(errorsMap1.isEmpty, true);

      // RecordService.create(), Now throws exception
      when(
        () => recordService.create(body: any(named: "body"))
      ).thenThrow(
        tc.clientException
      );

      // Check record is null, errorsMap is not empty
      final (record2, errorsMap2) = await invitationsRepository.create(body: {});
      expect(record2, null);
      expect(errorsMap2.isEmpty, false);
    });

    test("getList", () async {
      final tc = TestContext();

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final invitationsRepository = InvitationsRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(Collection.invitations)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.getList()
      when(
        () => recordService.getList(
          expand: any(named: "expand"),
          filter: any(named: "filter"),
          sort: any(named: "sort"),
        )
      ).thenAnswer(
        (_) async => ResultList<RecordModel>(
          items: [
            tc.getOpenInvitationRecordModel(),
            tc.getPrivateInvitationRecordModel(),
            tc.getOpenInvitationRecordModel(),
          ]
        )
      );

      // Check getList() is called at the right time
      verifyNever(() => recordService.getList(
        expand: any(named: "expand"),
        filter: any(named: "filter"),
        sort: any(named: "sort"),
      ));

      await invitationsRepository.getList();

      verify(() => recordService.getList(
        expand: any(named: "expand"),
        filter: any(named: "filter"),
        sort: any(named: "sort"),
      )).called(1);

      // RecordService.getList(), Now throws exception
      when(
        () => recordService.getList(
          expand: any(named: "expand"),
          filter: any(named: "filter"),
          sort: any(named: "sort"),
        )
      ).thenThrow(
        tc.clientException
      );
      // Check a ClientException is thrown
      expect(
        () async => await invitationsRepository.getList(),
        throwsA(predicate((e) => e is ClientException))
      );
    });

  });
}