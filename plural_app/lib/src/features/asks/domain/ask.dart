import 'package:intl/intl.dart';

// Authentication
import 'package:plural_app/src/features/authentication/domain/log_data.dart';

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

  String get formattedDeadlineDate {
    return DateFormat(Strings.dateformatYMMdd).format(deadlineDate);
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
    var records = await query.toJson()["items"];
    List<Ask> instances = [];

    for (var record in records) {
      // Format fullySponsoredDate if non-null
      var fullySponsoredDate = record["fullySponsoredDate"];
      var formattedFullySponsoredDate = fullySponsoredDate != "" ?
        DateTime.parse(fullySponsoredDate) : null;

      var newAsk = Ask(
        uid: record["id"],
        creatorUID: record["creator"],
        description: record["description"],
        deadlineDate: DateTime.parse(record["deadlineDate"]),
        targetDonationSum: record["targetDonationSum"],
        fullySponsoredDate: formattedFullySponsoredDate,
      );

      newAsk.sponsorIDS = List<String>.from(record["sponsors"]);

      instances.add(newAsk);
    }

    return instances;
  }
}