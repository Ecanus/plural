import 'package:test/test.dart';
import 'package:get_it/get_it.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import "package:plural_app/src/features/authentication/domain/app_user.dart";

// Utils
import 'package:plural_app/src/utils/app_state.dart';

void main() {
  group("Ask test", () {
    // AppUser
    final AppUser user = AppUser(
      email: "user@test.com",
      id: "TESTUSER1",
      username: "testuser1"
    );

    // Ask
    final Ask ask = Ask(
      id: "ASKID",
      boon: 5,
      creator: user,
      creationDate: DateTime(1996, 10, 28),
      currency: "CAD",
      description: "The description for the test Ask.",
      deadlineDate: DateTime(1996, 12, 25),
      instructions: "The instructions for the test Ask.",
      targetMetDate: null,
      targetSum: 70,
      type: AskType.monetary
    );

    // GetIt
    final getIt = GetIt.instance;
    getIt.registerLazySingleton<AppState>(
      () => AppState()
    );
    GetIt.instance<AppState>().currentUser = user;

    test("constructor", () {
      expect(ask.id == "ASKID", true);
      expect(ask.boon == 5, true);
      expect(ask.creator == user, true);
      expect(ask.creationDate == DateTime(1996, 10, 28), true);
      expect(ask.currency == "CAD", true);
      expect(ask.description == "The description for the test Ask.", true);
      expect(ask.deadlineDate == DateTime(1996, 12, 25), true);
      expect(ask.instructions == "The instructions for the test Ask.", true);
      expect(ask.targetMetDate == null, true);
      expect(ask.targetSum == 70, true);
      expect(ask.type == AskType.monetary, true);
    });

    test("formattedDeadlineDate", () {
      ask.deadlineDate = DateTime(1996, 12, 25);
      expect(ask.formattedDeadlineDate, "1996-12-25");
    });

    test("formattedTargetMetDate", () {
      ask.targetMetDate = null;
      expect(ask.formattedTargetMetDate, "");

      ask.targetMetDate = DateTime(1997, 1, 31);
      expect(ask.formattedTargetMetDate, "1997-01-31");
    });

    test("isCreatedByCurrentUser", () {
      expect(ask.isCreatedByCurrentUser, true);
    });

    test("isDeadlinePassed", () {
      ask.deadlineDate = DateTime.now().add(const Duration(days: -5));
      expect(ask.isDeadlinePassed, true);

      ask.deadlineDate = DateTime.now().add(const Duration(days: 5));
      expect(ask.isDeadlinePassed, false);
    });

    test("isOnTimeline", () {
      expect(ask.isOnTimeline, false);
    });

    test("isSponsoredByCurrentUser", () {
      ask.sponsorIDS.clear();
      expect(ask.isSponsoredByCurrentUser, false);

      ask.sponsorIDS.add(user.id);
      expect(ask.isSponsoredByCurrentUser, true);
    });

    test("isTargetMet", () {
      ask.targetMetDate = null;
      expect(ask.isTargetMet, false);

      ask.targetMetDate = DateTime(1997, 1, 31);
      expect(ask.isSponsoredByCurrentUser, true);
    });

    test("listTileDescription", () {
      ask.description = "A really really really really long description";
      expect(ask.listTileDescription, "A really really really really...");

      ask.description = "A short description";
      expect(ask.listTileDescription, "A short description");
    });

    test("timeRemainingString", () {
      ask.deadlineDate = DateTime.now().add(const Duration(days: 12));
      expect(ask.timeRemainingString.contains("days"), true);

      ask.deadlineDate = DateTime.now().add(const Duration(hours: 24));
      expect(ask.timeRemainingString.contains("day"), true);

      ask.deadlineDate = DateTime.now().add(const Duration(hours: 3));
      expect(ask.timeRemainingString.contains("hours"), true);

      ask.deadlineDate = DateTime.now().add(const Duration(hours: 1));
      expect(ask.timeRemainingString.contains("hour"), true);

      ask.deadlineDate = DateTime.now().add(const Duration(minutes: 49));
      expect(ask.timeRemainingString.contains("minutes"), true);

      ask.deadlineDate = DateTime.now().add(const Duration(minutes: 1));
      expect(ask.timeRemainingString.contains("minute"), true);
    });

    test("truncatedDescription", () {
      ask.description = "A short description";
      expect(ask.truncatedDescription, "A short description");

      var really40 = "really " * 40;
      var really28 = "really " * 28;
      ask.description = really40;
      expect(ask.truncatedDescription, "${really28.trim()} real...");
    });

    test("isSponsoredByUser", () {
      ask.sponsorIDS.add("TESTUSER2");
      expect(ask.isSponsoredByUser("TESTUSER2"), true);

      ask.sponsorIDS.clear();
      expect(ask.isSponsoredByUser("TESTUSER2"), false);
    });

    test("toMap", () {
      ask.boon = 5;
      ask.currency = "CAD";
      ask.description = "Ask description";
      ask.deadlineDate = DateTime(1996, 12, 25);
      ask.instructions = "Ask instructions";
      ask.targetMetDate = null;
      ask.targetSum = 70;
      ask.type = AskType.monetary;

      var askMap = {
        "id": "ASKID",
        "boon": 5,
        "creator": user.id,
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