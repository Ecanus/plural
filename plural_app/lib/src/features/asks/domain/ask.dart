import 'package:flutter/material.dart' show InlineSpan, TextSpan;
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';

// Common Functions
import 'package:plural_app/src/common_functions/markdown.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';

// Auth
import "package:plural_app/src/features/authentication/domain/app_user.dart";

// Utils
import 'package:plural_app/src/utils/app_state.dart';

enum AskType { monetary, }

class Ask {
  Ask({
    required this.id,
    required this.boon,
    required this.creator,
    required this.creationDate,
    required this.currency,
    required this.deadlineDate,
    required this.description,
    required this.instructions,
    this.targetMetDate,
    required this.targetSum,
    required this.type,
  });

  final String id;
  int boon;
  final AppUser creator;
  final DateTime creationDate;
  String currency;
  DateTime deadlineDate;
  String description;
  String instructions;
  DateTime? targetMetDate;
  int targetSum;
  AskType type;

  List<String> sponsorIDS = [];

  String get formattedDeadlineDate =>
    DateFormat(Formats.dateYMMdd).format(deadlineDate);

  String get formattedTargetMetDate {
    if (targetMetDate == null) return "";

    return DateFormat(Formats.dateYMMdd).format(targetMetDate!.toLocal());
  }

  bool get isCreatedByCurrentUser =>
    creator.id == GetIt.instance<AppState>().currentUserID!;

  bool get isDeadlinePassed => deadlineDate.isBefore(DateTime.now());

  bool get isOnTimeline => GetIt.instance<AppState>().timelineAsks!.contains(this);

  bool get isSponsoredByCurrentUser =>
    sponsorIDS.contains(GetIt.instance<AppState>().currentUserID!);

  bool get isTargetMet => targetMetDate != null;

  String get listTileDescription {
    var limit = AppMaxLengths.max30;

    if (description.length > limit) {
      return "${description.substring(0, limit).trim()}...";
    } else {
      return description;
    }
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
    if (minutesLeft > 1) return "$minutesLeft minutes left";

    return "$minutesLeft minute left";
  }

  String get truncatedDescription {
    const limit = AppMaxLengths.max200;

    // First convert "[link_text](link_address)" markdown to just "link_text"
    List<InlineSpan> strippedDescriptionSpans = stripHttpMarkdown(text: description);
    var parsedDescription = strippedDescriptionSpans.fold(
      "",
      (previous, current) {
        return "$previous${(current as TextSpan).text!}";
      }
    );

    // Return truncated text after the markdown conversion
    if (parsedDescription.length > limit) {
      return "${parsedDescription.substring(0, limit).trim()}...";
    } else {
      return parsedDescription;
    }
  }

  bool isSponsoredByUser(String userID) {
    // The creator of an Ask cannot sponsor that ask
    if (creator.id == userID) return false;

    return sponsorIDS.contains(userID);
  }

  Map toMap() {
    return {
      GenericField.id: id,
      AskField.boon: boon,
      AskField.creator: creator.id,
      AskField.currency: currency,
      AskField.description: description,
      AskField.deadlineDate: deadlineDate,
      AskField.instructions: instructions,
      AskField.targetMetDate: targetMetDate,
      AskField.targetSum: targetSum,
      AskField.type: type.name,
    };
  }

  static Map emptyMap() {
    return {
      GenericField.id: null,
      AskField.boon: null,
      AskField.currency: null,
      AskField.description: null,
      AskField.deadlineDate: null,
      AskField.instructions: null,
      AskField.targetMetDate: null,
      AskField.targetSum: null,
      AskField.type: null,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ask && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}