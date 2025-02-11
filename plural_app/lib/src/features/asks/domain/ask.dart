import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';

// Auth
import "package:plural_app/src/features/authentication/domain/app_user.dart";
import "package:plural_app/src/features/authentication/data/auth_repository.dart";

// Constants
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/app_values.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

enum AskType { monetary, }

class Ask {
  Ask({
    required this.id,
    required this.boon,
    required this.creatorID,
    required this.creationDate,
    required this.currency,
    required this.description,
    required this.deadlineDate,
    this.targetMetDate,
    required this.targetSum,
    required this.type,
  });

  final String id;
  int boon;
  final String creatorID;
  DateTime creationDate;
  String currency;
  String description;
  DateTime deadlineDate;
  DateTime? targetMetDate;
  int targetSum;
  AskType type;

  List<String> sponsorIDS = [];

  AppUser? creator;

  String get formattedDeadlineDate {
    return DateFormat(Strings.dateformatYMMdd).format(deadlineDate);
  }

  String get truncatedDescription {
    var limit = AppMaxLengthValues.max200;

    if (description.length > limit) {
      return "${description.substring(0, limit)}...";
    } else {
      return description;
    }
  }

  bool get isTargetMet {
    return targetMetDate != null;
  }

  String get timeRemainingString {
    var timeRemaining = deadlineDate.difference(DateTime.now());

    var daysLeft = timeRemaining.inDays;
    var hoursLeft = timeRemaining.inHours;
    var minutesLeft = timeRemaining.inMinutes;

    // Days
    if (daysLeft == 1) return "$daysLeft day left";
    if (daysLeft > 0) return "$daysLeft days left";

    // Hours
    if (hoursLeft == 1) return "$hoursLeft hour left";
    if (hoursLeft > 0) return "$hoursLeft hours left";

    // Minutes
    if (minutesLeft > 0) return "$minutesLeft minutes left";

    return "$minutesLeft minute left";
  }

  bool get isCreatedByCurrentUser {
    return creatorID == GetIt.instance<AppState>().currentUserID!;
  }

  bool get isSponsoredByCurrentUser {
    return sponsorIDS.contains(GetIt.instance<AppState>().currentUserID!);
  }

  bool isSponsoredByUser(String userID) {
    // The creator of an Ask cannot sponsor that ask
    if (creatorID == userID) return false;

    return sponsorIDS.contains(userID);
  }

  int compareTo(Ask other) {
    // Compare on logCreationDate first
    var creationCompare = creationDate.compareTo(other.creationDate);
    if (creationCompare != 0) return creationCompare;

    // If equal on creationDate, compare on deadlineDate
    return deadlineDate.compareTo(other.deadlineDate);
  }

  static Future<List<Ask>> createInstancesFromQuery(
    query,
    { int? count }) async {
      final authRepository = GetIt.instance<AuthRepository>();

      var records = query.toJson()[PBKey.items];

      if (count != null && records.length >= count) {
        records = records.sublist(0, count);
      }

      List<Ask> instances = [];

      for (var record in records) {
        var creatorID = record[AskField.creator];

        // Format targetMetDate if non-null
        var targetMetDateString = record[AskField.targetMetDate];
        var formattedTargetMetDate = targetMetDateString != "" ?
          DateTime.parse(targetMetDateString) : null;

        // Get AppUser that created the Ask
        var creator = await authRepository.getUserByID(creatorID);

        // Get type enum from the record (a string)
        var askTypeFromString = AskType.values.firstWhere(
          (a) => a.name == "AskType.${record[AskField.type]}",
          orElse: () => AskType.monetary
        );

        var newAsk = Ask(
          id: record[GenericField.id],
          boon: record[AskField.boon],
          creatorID: creatorID,
          creationDate: DateTime.parse(record[GenericField.created]),
          currency: record[AskField.currency],
          description: record[AskField.description],
          deadlineDate: DateTime.parse(record[AskField.deadlineDate]),
          targetSum: record[AskField.targetSum],
          targetMetDate: formattedTargetMetDate,
          type: askTypeFromString
        );

        newAsk.sponsorIDS = List<String>.from(record[AskField.sponsors]);
        newAsk.creator = creator;

        instances.add(newAsk);
      }

      return instances;
  }

  Map toMap() {
    return {
      GenericField.id: id,
      AskField.boon: boon,
      AskField.creatorID: creatorID,
      AskField.currency: currency,
      AskField.description: description,
      AskField.deadlineDate: deadlineDate,
      AskField.targetSum: targetSum,
      AskField.targetMetDate: targetMetDate,
      AskField.type: type.name, //TODO: Remove ".name" once a FormField is made for this
    };
  }

  static Map emptyMap() {
    return {
      GenericField.id: null,
      AskField.boon: null,
      AskField.currency: null,
      AskField.description: null,
      AskField.deadlineDate: null,
      AskField.targetSum: null,
      AskField.targetMetDate: null,
      AskField.type: AskType.monetary.name, // TODO: Remove ".name", Currently all Asks are monetary
    };
  }
}