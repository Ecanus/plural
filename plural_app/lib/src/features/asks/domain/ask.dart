import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/log_data.dart';
import "package:plural_app/src/features/authentication/domain/app_user.dart";
import "package:plural_app/src/features/authentication/data/auth_repository.dart";

// Constants
import 'package:plural_app/src/constants/strings.dart';

class Ask with LogData{
  Ask({
    required this.uid,
    required this.creatorUID,
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

  final String uid;
  final String creatorUID;
  String description;
  DateTime deadlineDate;
  DateTime? fullySponsoredDate;
  int targetDonationSum;

  List<String> sponsorIDS = [];

  AppUser? creator;

  String get formattedDeadlineDate {
    return DateFormat(Strings.dateformatYMMdd).format(deadlineDate);
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

  bool isSponsoredByUser(String userUID) {
    // The creator of an Ask cannot sponsor that ask
    if (creatorUID == userUID) return false;

    return sponsorIDS.contains(userUID);
  }

  int compareTo(Ask other) {
    // Compare on logCreationDate first
    var creationCompare = logCreationDate.compareTo(other.logCreationDate);
    if (creationCompare != 0) return creationCompare;

    // If equal on logCreationDate, compare on deadlineDate
    return deadlineDate.compareTo(other.deadlineDate);
  }

  static Future<List<Ask>> createInstancesFromQuery(query) async {
    final authRepository = GetIt.instance<AuthRepository>();

    var records = await query.toJson()["items"];
    List<Ask> instances = [];

    for (var record in records) {
      var creatorUID = record["creator"];

      // Format fullySponsoredDate if non-null
      var fullySponsoredDate = record["fullySponsoredDate"];
      var formattedFullySponsoredDate = fullySponsoredDate != "" ?
        DateTime.parse(fullySponsoredDate) : null;

      // Get AppUser that created the Ask
      var creator = await authRepository.getUserByUID(creatorUID);

      var newAsk = Ask(
        uid: record["id"],
        creatorUID: creatorUID,
        description: record["description"],
        deadlineDate: DateTime.parse(record["deadlineDate"]),
        targetDonationSum: record["targetDonationSum"],
        fullySponsoredDate: formattedFullySponsoredDate,
      );

      newAsk.sponsorIDS = List<String>.from(record["sponsors"]);
      newAsk.creator = creator;

      instances.add(newAsk);
    }

    return instances;
  }
}