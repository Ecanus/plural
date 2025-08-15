import 'package:test/test.dart';
import 'package:get_it/get_it.dart';

import 'package:plural_app/src/features/asks/domain/ask.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_factories.dart';

void main() {
  group("Ask", () {
    test("constructor", () {
      final user = AppUserFactory();
      final ask = AskFactory(
        boon: 5,
        creator: user,
        creationDate: DateTime(1995, 06, 13),
        currency: "GHS",
        deadlineDate: DateTime(1995, 07, 24),
        description: "Test description of test-ask-constructor",
        id: "test-ask-constructor",
        instructions: "Test instructions of test-ask-constructor",
        targetMetDate: null,
        targetSum: 160,
      );

      expect(ask.boon == 5, true);
      expect(ask.creator == user, true);
      expect(ask.creationDate == DateTime(1995, 06, 13), true);
      expect(ask.currency == "GHS", true);
      expect(ask.deadlineDate == DateTime(1995, 07, 24), true);
      expect(ask.description == "Test description of test-ask-constructor", true);
      expect(ask.id == "test-ask-constructor", true);
      expect(ask.instructions == "Test instructions of test-ask-constructor", true);
      expect(ask.targetMetDate == null, true);
      expect(ask.targetSum == 160, true);
      expect(ask.type == AskType.monetary, true);
    });

    tearDown(() => GetIt.instance.reset());

    test("formattedDeadlineDate", () {
      final ask = AskFactory();

      ask.deadlineDate = DateTime(1996, 12, 25);
      expect(ask.formattedDeadlineDate, "1996-12-25");
    });

    test("formattedTargetMetDate", () {
      final ask = AskFactory();

      ask.targetMetDate = null;
      expect(ask.formattedTargetMetDate, "");

      ask.targetMetDate = DateTime(1997, 1, 31);
      expect(ask.formattedTargetMetDate, "1997-01-31");
    });

    test("isCreatedByCurrentUser", () {
      final user = AppUserFactory();
      final ask = AskFactory(creator: user);

      // GetIt
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => AppState());
      GetIt.instance<AppState>().currentUser = user;

      expect(ask.isCreatedByCurrentUser, true);
    });

    tearDown(() => GetIt.instance.reset());

    test("isDeadlinePassed", () {
      final ask = AskFactory();

      ask.deadlineDate = DateTime.now().add(const Duration(days: -5));
      expect(ask.isDeadlinePassed, true);

      ask.deadlineDate = DateTime.now().add(const Duration(days: 5));
      expect(ask.isDeadlinePassed, false);
    });

    test("isOnTimeline", () async {
      final ask = AskFactory();

      // false. Both deadlineDate and targetMetDate have passed
      ask.deadlineDate = DateTime.now().add(const Duration(days: -5));
      ask.targetMetDate = DateTime.now().add(const Duration(days: -7));
      expect(ask.isOnTimeline, false);

      // false. deadlineDate has passed
      ask.deadlineDate = DateTime.now().add(const Duration(days: -5));
      ask.targetMetDate = null;
      expect(ask.isOnTimeline, false);

      // false. targetMetDate has passed
      ask.deadlineDate = DateTime.now().add(const Duration(days: 5));
      ask.targetMetDate = DateTime.now().add(const Duration(days: -7));
      expect(ask.isOnTimeline, false);

      // true. deadlineDate has not passed. targetMetDate is null
      ask.deadlineDate = DateTime.now().add(const Duration(days: 5));
      ask.targetMetDate = null;
      expect(ask.isOnTimeline, true);
    });

    test("isSponsoredByCurrentUser", () {
      final user = AppUserFactory();
      final ask = AskFactory();

      // GetIt
      final getIt = GetIt.instance;
      final appState = AppState()
        ..currentUser = user;

      getIt.registerLazySingleton<AppState>(() => appState);

      ask.sponsorIDS.clear();
      expect(ask.isSponsoredByCurrentUser, false);

      ask.sponsorIDS.add(user.id);
      expect(ask.isSponsoredByCurrentUser, true);
    });

    tearDown(() => GetIt.instance.reset());

    test("isTargetMet", () {
      final ask = AskFactory();

      ask.targetMetDate = null;
      expect(ask.isTargetMet, false);

      ask.targetMetDate = DateTime(1997, 1, 31);
      expect(ask.isTargetMet, true);
    });

    test("listTileDescription", () {
      final ask = AskFactory();

      ask.description = "A really really really really long description";
      expect(ask.listTileDescription, "A really really really really...");

      ask.description = "A short description";
      expect(ask.listTileDescription, "A short description");
    });

    test("timeRemainingString", () {
      final ask = AskFactory();

      ask.deadlineDate = DateTime.now().add(const Duration(days: 12));
      expect(ask.timeRemainingString.contains("days"), true);

      ask.deadlineDate = DateTime.now().add(const Duration(hours: 3));
      expect(ask.timeRemainingString.contains("hours"), true);

      ask.deadlineDate = DateTime.now().add(const Duration(minutes: 49));
      expect(ask.timeRemainingString.contains("minutes"), true);
    });

    test("truncatedDescription", () {
      final ask = AskFactory();

      ask.description = "A short description";
      expect(ask.truncatedDescription, "A short description");

      var really40 = "really " * 40;
      var really28 = "really " * 28;
      ask.description = really40;
      expect(ask.truncatedDescription, "${really28.trim()} real...");
    });

    test("isSponsoredByUser", () {
      final ask = AskFactory();

      ask.sponsorIDS.add("TESTUSER2");
      expect(ask.isSponsoredByUser("TESTUSER2"), true);

      ask.sponsorIDS.clear();
      expect(ask.isSponsoredByUser("TESTUSER2"), false);
    });

    test("toMap", () {
      final user = AppUserFactory();
      final ask = AskFactory(
        boon: 5,
        creator: user,
        currency: "CAD",
        deadlineDate: DateTime(1996, 12, 25),
        description: "Ask description",
        id: "test-ask-toMap",
        instructions: "Ask instructions",
        targetMetDate: null,
        targetSum: 70,
      );

      var askMap = {
        "boon": 5,
        "creator": user.id,
        "currency": "CAD",
        "deadlineDate": DateTime(1996, 12, 25),
        "description": "Ask description",
        "id": "test-ask-toMap",
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
      final user = AppUserFactory();
      final ask = AskFactory();

      // Identity
      expect(ask == ask, true);

      Ask otherAskSameID = Ask(
        id: ask.id,
        boon: 250,
        creator: user,
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
        creator: user,
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