import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/log_data.dart';
import "package:plural_app/src/features/authentication/domain/app_user.dart";
import "package:plural_app/src/features/authentication/data/auth_repository.dart";

// Constants
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/app_values.dart';

class Ask with LogData{
  Ask({
    required this.id,
    required this.creatorID,
    required this.description,
    required this.deadlineDate,
    required this.targetDonationSum,
    this.fullySponsoredDate,
  });

  // Log Data
  @override
  DateTime get logCreationDate {
    return DateTime.now();
  }

  final String id;
  final String creatorID;
  String description;
  DateTime deadlineDate;
  DateTime? fullySponsoredDate;
  int targetDonationSum;

  List<String> sponsorIDS = [];

  AppUser? creator;

  String get formattedDeadlineDate {
    return DateFormat(Strings.dateformatYMMdd).format(deadlineDate);
  }

  String get truncatedDescription {
    if (description.length > AppMaxLengthValues.max50) {
      return "${description.substring(0, AppMaxLengthValues.max50)}...";
    } else {
      return description;
    }
  }

  bool get isFullySponsored {
    return fullySponsoredDate != null;
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
    if (minutesLeft == 1) return "$minutesLeft minute left";
    if (minutesLeft > 0) return "$minutesLeft minutes left";

    return "< $minutesLeft minutes left";
  }

  bool isSponsoredByUser(String userID) {
    // The creator of an Ask cannot sponsor that ask
    if (creatorID == userID) return false;

    return sponsorIDS.contains(userID);
  }

  int compareTo(Ask other) {
    // Compare on logCreationDate first
    var creationCompare = logCreationDate.compareTo(other.logCreationDate);
    if (creationCompare != 0) return creationCompare;

    // If equal on logCreationDate, compare on deadlineDate
    return deadlineDate.compareTo(other.deadlineDate);
  }

  static Future<List<Ask>> createInstancesFromQuery(
    query,
    { int? count
    }) async {
      final authRepository = GetIt.instance<AuthRepository>();

      var records = query.toJson()[PBKey.items];

      if (count != null && records.length >= count) {
        records = records.sublist(0, count);
      }

      List<Ask> instances = [];

      for (var record in records) {
        var creatorID = record[AskField.creator];

        // Format fullySponsoredDate if non-null
        var fullySponsoredDate = record[AskField.fullySponsoredDate];
        var formattedFullySponsoredDate = fullySponsoredDate != "" ?
          DateTime.parse(fullySponsoredDate) : null;

        // Get AppUser that created the Ask
        var creator = await authRepository.getUserByID(creatorID);

        var newAsk = Ask(
          id: record[GenericField.id],
          creatorID: creatorID,
          description: record[AskField.description],
          deadlineDate: DateTime.parse(record[AskField.deadlineDate]),
          targetDonationSum: record[AskField.targetDonationSum],
          fullySponsoredDate: formattedFullySponsoredDate,
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
      AskField.creatorID: creatorID,
      AskField.description: description,
      AskField.deadlineDate: deadlineDate,
      AskField.targetDonationSum: targetDonationSum,
      AskField.fullySponsoredDate: fullySponsoredDate,
    };
  }

  static Map emptyMap() {
    return {
      GenericField.id: null,
      AskField.description: null,
      AskField.deadlineDate: null,
      AskField.targetDonationSum: null,
      AskField.fullySponsoredDate: null,
    };
  }
}