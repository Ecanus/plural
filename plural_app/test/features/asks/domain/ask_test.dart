import 'package:test/test.dart';
import 'package:get_it/get_it.dart';

import 'package:plural_app/src/features/asks/domain/ask.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("Ask", () {
    test("constructor", () {
      final tc = TestContext();
      final ask = tc.ask;

      // GetIt
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => AppState());
      GetIt.instance<AppState>().currentUser = tc.user;

      expect(ask.id == "TESTASK1", true);
      expect(ask.boon == 15, true);
      expect(ask.creator == tc.user, true);
      expect(ask.creationDate == DateTime(1995, 06, 13), true);
      expect(ask.currency == "GHS", true);
      expect(ask.description == "Test description of TESTASK1", true);
      expect(ask.deadlineDate == DateTime(1995, 07, 24), true);
      expect(ask.instructions == "Test instructions of TESTASK1", true);
      expect(ask.targetMetDate == null, true);
      expect(ask.targetSum == 160, true);
      expect(ask.type == AskType.monetary, true);
    });

    tearDown(() => GetIt.instance.reset());

    test("formattedDeadlineDate", () {
      final tc = TestContext();

      tc.ask.deadlineDate = DateTime(1996, 12, 25);
      expect(tc.ask.formattedDeadlineDate, "1996-12-25");
    });

    test("formattedTargetMetDate", () {
      final tc = TestContext();
      final ask = tc.ask;

      ask.targetMetDate = null;
      expect(ask.formattedTargetMetDate, "");

      ask.targetMetDate = DateTime(1997, 1, 31);
      expect(ask.formattedTargetMetDate, "1997-01-31");
    });

    test("isCreatedByCurrentUser", () {
      final tc = TestContext();

      // GetIt
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => AppState());
      GetIt.instance<AppState>().currentUser = tc.user;

      expect(tc.ask.isCreatedByCurrentUser, true);
    });

    tearDown(() => GetIt.instance.reset());

    test("isDeadlinePassed", () {
      final tc = TestContext();
      final ask = tc.ask;

      ask.deadlineDate = DateTime.now().add(const Duration(days: -5));
      expect(ask.isDeadlinePassed, true);

      ask.deadlineDate = DateTime.now().add(const Duration(days: 5));
      expect(ask.isDeadlinePassed, false);
    });

    test("isOnTimeline", () async {
      final tc = TestContext();

      // false. Both deadlineDate and targetMetDate have passed
      tc.ask.deadlineDate = DateTime.now().add(const Duration(days: -5));
      tc.ask.targetMetDate = DateTime.now().add(const Duration(days: -7));
      expect(tc.ask.isOnTimeline, false);

      // false. deadlineDate has passed
      tc.ask.deadlineDate = DateTime.now().add(const Duration(days: -5));
      tc.ask.targetMetDate = null;
      expect(tc.ask.isOnTimeline, false);

      // false. targetMetDate has passed
      tc.ask.deadlineDate = DateTime.now().add(const Duration(days: 5));
      tc.ask.targetMetDate = DateTime.now().add(const Duration(days: -7));
      expect(tc.ask.isOnTimeline, false);

      // true. deadlineDate has not passed. targetMetDate is null
      tc.ask.deadlineDate = DateTime.now().add(const Duration(days: 5));
      tc.ask.targetMetDate = null;
      expect(tc.ask.isOnTimeline, true);
    });

    test("isSponsoredByCurrentUser", () {
      final tc = TestContext();
      final ask = tc.ask;

      // GetIt
      final getIt = GetIt.instance;
      final appState =
              AppState()
              ..currentUser = tc.user;

      getIt.registerLazySingleton<AppState>(() => appState);

      ask.sponsorIDS.clear();
      expect(ask.isSponsoredByCurrentUser, false);

      ask.sponsorIDS.add(tc.user.id);
      expect(ask.isSponsoredByCurrentUser, true);
    });

    tearDown(() => GetIt.instance.reset());

    test("isTargetMet", () {
      final tc = TestContext();
      final ask = tc.ask;

      ask.targetMetDate = null;
      expect(ask.isTargetMet, false);

      ask.targetMetDate = DateTime(1997, 1, 31);
      expect(ask.isTargetMet, true);
    });

    test("listTileDescription", () {
      final tc = TestContext();

      tc.ask.description = "A really really really really long description";
      expect(tc.ask.listTileDescription, "A really really really really...");

      tc.ask.description = "A short description";
      expect(tc.ask.listTileDescription, "A short description");
    });

    test("timeRemainingString", () {
      final tc = TestContext();
      final ask = tc.ask;

      ask.deadlineDate = DateTime.now().add(const Duration(days: 12));
      expect(ask.timeRemainingString.contains("days"), true);

      ask.deadlineDate = DateTime.now().add(const Duration(hours: 3));
      expect(ask.timeRemainingString.contains("hours"), true);

      ask.deadlineDate = DateTime.now().add(const Duration(minutes: 49));
      expect(ask.timeRemainingString.contains("minutes"), true);
    });

    test("truncatedDescription", () {
      final tc = TestContext();
      final ask = tc.ask;

      ask.description = "A short description";
      expect(ask.truncatedDescription, "A short description");

      var really40 = "really " * 40;
      var really28 = "really " * 28;
      ask.description = really40;
      expect(ask.truncatedDescription, "${really28.trim()} real...");
    });

    test("isSponsoredByUser", () {
      final tc = TestContext();
      final ask = tc.ask;

      ask.sponsorIDS.add("TESTUSER2");
      expect(ask.isSponsoredByUser("TESTUSER2"), true);

      ask.sponsorIDS.clear();
      expect(ask.isSponsoredByUser("TESTUSER2"), false);
    });

    test("toMap", () {
      final tc = TestContext();
      final ask = tc.ask;

      ask.boon = 5;
      ask.currency = "CAD";
      ask.description = "Ask description";
      ask.deadlineDate = DateTime(1996, 12, 25);
      ask.instructions = "Ask instructions";
      ask.targetMetDate = null;
      ask.targetSum = 70;
      ask.type = AskType.monetary;

      var askMap = {
        "id": "TESTASK1",
        "boon": 5,
        "creator": tc.user.id,
        "currency": "CAD",
        "description": "Ask description",
        "deadlineDate": DateTime(1996, 12, 25),
        "instructions": "Ask instructions",
        "targetMetDate": null,
        "targetSum": 70,
        "type": AskType.monetary.name
      };

      expect(ask.toMap(), askMap);
    });

    test("emptyMap", () {
      var emptyMap = {
        "id": null,
        "boon": null,
        "currency": null,
        "description": null,
        "deadlineDate": null,
        "instructions": null,
        "targetMetDate": null,
        "targetSum": null,
        "type": null
      };

      expect(Ask.emptyMap(), emptyMap);
    });

    test("==", () {
      final tc = TestContext();
      final ask = tc.ask;

      // Identity
      expect(ask == ask, true);

      Ask otherAskSameID = Ask(
        id: ask.id,
        boon: 250,
        creator: tc.user,
        creationDate: DateTime(2001, 1, 3),
        currency: "GHS",
        description: "The description for the OTHER test Ask.",
        deadlineDate: DateTime(2001, 12, 23),
        instructions: "The instructions for the OTHER test Ask.",
        targetMetDate: null,
        targetSum: 9999,
        type: AskType.monetary
      );

      expect(ask == otherAskSameID, true);

      Ask otherAskDifferentID = Ask(
        id: "OTHERASKID",
        boon: 250,
        creator: tc.user,
        creationDate: DateTime(2001, 1, 3),
        currency: "GHS",
        description: "The description for the OTHER test Ask.",
        deadlineDate: DateTime(2001, 12, 23),
        instructions: "The instructions for the OTHER test Ask.",
        targetMetDate: null,
        targetSum: 9999,
        type: AskType.monetary
      );

      expect(ask == otherAskDifferentID, false);
    });
  });
}