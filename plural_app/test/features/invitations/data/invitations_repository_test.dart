import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Invitations
import 'package:plural_app/src/features/invitations/data/invitations_repository.dart';
import 'package:plural_app/src/features/invitations/domain/invitation.dart';

// Tests
import '../../../test_factories.dart';
import '../../../test_mocks.dart';

void main() {
  group("InvitationsRepository", () {
    test("create", () async {
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
        (_) async => getOpenInvitationRecordModel()
      );

      // Check record is not null, and errorsMap is empty
      final (record1, errorsMap1) = await invitationsRepository.create(body: {});
      expect(record1, isNotNull);
      expect(errorsMap1.isEmpty, true);

      // RecordService.create(), Now throws exception
      when(
        () => recordService.create(body: any(named: "body"))
      ).thenThrow(
        ClientExceptionFactory(fieldName: InvitationField.creator)
      );

      // Check record is null, errorsMap is not empty
      final (record2, errorsMap2) = await invitationsRepository.create(body: {});
      expect(record2, null);
      expect(errorsMap2.isEmpty, false);
    });

    test("delete", () async {
      final openInvitation = InvitationFactory(type: InvitationType.open);

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final invitationsRepository = InvitationsRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(Collection.invitations)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.delete()
      when(
        () => recordService.delete(openInvitation.id)
      ).thenAnswer(
        (_) async => {}
      );

      verifyNever(() => recordService.delete(any()));
      await invitationsRepository.delete(id: openInvitation.id);
      verify(() => recordService.delete(any())).called(1);

      // RecordService.delete(), Now throws exception
      when(
        () => recordService.delete(any())
      ).thenThrow(
        ClientExceptionFactory(fieldName: InvitationField.creator)
      );
      // Check a ClientException is thrown
      expect(
        () async => await invitationsRepository.delete(id: openInvitation.id),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("getList", () async {
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
            getOpenInvitationRecordModel(),
            getPrivateInvitationRecordModel(),
            getOpenInvitationRecordModel(),
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
        ClientExceptionFactory(fieldName: InvitationField.creator)
      );
      // Check a ClientException is thrown
      expect(
        () async => await invitationsRepository.getList(),
        throwsA(predicate((e) => e is ClientException))
      );
    });

    test("update", () async {
      final openInvitation = InvitationFactory(type: InvitationType.open);

      final body = {
        InvitationField.expiryDate: DateFormat(Formats.dateYMMdd).format(DateTime.now()),
      };

      final pb = MockPocketBase();
      final recordService = MockRecordService();
      final invitationsRepository = InvitationsRepository(pb: pb);

      // pb.collection()
      when(
        () => pb.collection(Collection.invitations)
      ).thenAnswer(
        (_) => recordService as RecordService
      );

      // RecordService.update()
      when(
        () => recordService.update(
          openInvitation.id,
          body: body
        )
      ).thenAnswer(
        (_) async => getOpenInvitationRecordModel()
      );

      // Check record is not null, and errorsMap is empty
      final (record, errorsMap) = await invitationsRepository.update(
        id: openInvitation.id,
        body: body
      );
      expect(record, isNotNull);
      expect(errorsMap.isEmpty, true);

      // RecordService.update(), Now throws exception
      when(
        () => recordService.update(
          openInvitation.id,
          body: body
        )
      ).thenThrow(
        ClientExceptionFactory(fieldName: InvitationField.creator)
      );

      // Check record is null, errorsMap is not empty
      final (record2, errorsMap2) = await invitationsRepository.update(
        id: openInvitation.id, body: body);

      expect(record2, null);
      expect(errorsMap2.isEmpty, false);
    });
  });
}