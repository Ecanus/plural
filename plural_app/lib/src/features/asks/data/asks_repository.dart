import 'dart:developer' as developer;

import 'package:pocketbase/pocketbase.dart';
import 'package:get_it/get_it.dart';

// Common Functions
import 'package:plural_app/src/common_functions/errors.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/strings.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import "package:plural_app/src/features/authentication/data/auth_repository.dart";

// Utils
import 'package:plural_app/src/utils/app_state.dart';

/// Iterates over the given [query] to generate a list of [Ask] instances.
///
/// Returns a list of the created [Ask] instances.
Future<List<Ask>> createAskInstancesFromQuery(
  query,
  { int? count }
) async {
    final authRepository = GetIt.instance<AuthRepository>();

    var records = query.toJson()[PBKey.items];

    if (count != null && records.length >= count) {
      records = records.sublist(0, count);
    }

    List<Ask> instances = [];

    for (var record in records) {
      var creatorID = record[AskField.creator];

      // Parse targetMetDate if non-null
      String targetMetDateString = record[AskField.targetMetDate];
      DateTime? parsedTargetMetDate = targetMetDateString.isNotEmpty ?
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
        instructions: record[AskField.instructions],
        targetSum: record[AskField.targetSum],
        targetMetDate: parsedTargetMetDate,
        type: askTypeFromString
      );

      newAsk.sponsorIDS = List<String>.from(record[AskField.sponsors]);
      newAsk.creator = creator;

      instances.add(newAsk);
    }

    return instances;
}

class AsksRepository {
  AsksRepository({
    required this.pb,
  });

  final PocketBase pb;

  /// Queries on the [Ask] collection to retrieve records corresponding to the
  /// given [gardenID] and [filterString].
  ///
  /// Returns the list of retrieved [Ask]s.
  Future<List<Ask>> getAsksByGardenID({
    required String gardenID,
    int? count,
    String filterString = "",
    String sortString = "deadlineDate,created",
    }) async {
      filterString = filterString.isEmpty ? "garden = '$gardenID'" : filterString;

      var result = await pb.collection(Collection.asks).getList(
        filter: filterString,
        sort: sortString
      );

      // Sorting from query is maintained for returned List<Ask>
      return await createAskInstancesFromQuery(result, count: count);
  }

  /// Queries on the [Ask] collection to retrieve all records corresponding
  /// to the given [userID] and the current [Garden].
  ///
  /// Returns the list of retrieved [Ask]s
  Future<List<Ask>> getAsksByUserID({required String userID}) async {
    final currentGarden = GetIt.instance<AppState>().currentGarden!;

    var result = await pb.collection(Collection.asks).getList(
      sort: "${AskField.targetMetDate},${AskField.deadlineDate},${GenericField.created}",
      filter: """
          ${AskField.creator} = '$userID' &&
          ${AskField.garden} = '${currentGarden.id}'
          """
    );

    return await createAskInstancesFromQuery(result);
  }

  /// Appends the [User] record which corresponds to the given [userID] to the list
  /// of sponsors of the [Ask] record which corresponds to the given [askID].
  Future addSponsor(String askID, String userID) async {
    var result = await pb.collection(Collection.asks).getList(
      filter: "${GenericField.id}='$askID'"
    );

    // If ask already contains sponsor, return
    var record = result.toJson()[PBKey.items][0];
    var currentSponsors = List<String>.from(record[AskField.sponsors]);
    if (currentSponsors.contains(userID)) return;

    // Else update
    currentSponsors.add(userID);
    var body = { AskField.sponsors: currentSponsors};

    await pb.collection(Collection.asks).update(
      askID,
      body: body,
    );
  }

  /// Removes the [User] record which corresponds to the given [userID] from the list
  /// of sponsors of the [Ask] record which corresponds to the given [askID].
  Future removeSponsor(String askID, String userID) async {
    var result = await pb.collection(Collection.asks).getList(
      filter: "${GenericField.id}='$askID'"
    );

    // If ask does not contain sponsor, return
    var record = result.toJson()[PBKey.items][0];
    var currentSponsors = List<String>.from(record[AskField.sponsors]);
    if (!currentSponsors.contains(userID)) return;

    // Else update
    currentSponsors.remove(userID);
    var body = { AskField.sponsors: currentSponsors};

    await pb.collection(Collection.asks).update(
      askID,
      body: body,
    );
  }

  /// Queries on the [Ask] collection to create a record corresponding
  /// to information in the [map] parameter.
  ///
  /// Returns (true, {}) if created successfully, else false
  /// and a map of the errors.
  Future<(bool, Map)> create(Map map) async {
    try {
      var appState = GetIt.instance<AppState>();

      // Create Ask
      await pb.collection(Collection.asks).create(
        body: {
          AskField.boon: map[AskField.boon],
          AskField.creator: appState.currentUserID!,
          AskField.currency: map[AskField.currency],
          AskField.description: map[AskField.description],
          AskField.deadlineDate: map[AskField.deadlineDate],
          AskField.garden: appState.currentGarden!.id,
          AskField.instructions: map[AskField.instructions],
          AskField.targetSum: map[AskField.targetSum],
          AskField.type: map[AskField.type],
        }
      );

      // Return
      return (true, {});
    } on ClientException catch(e) {
      var errorsMap = getErrorsMapFromClientException(e);

      // Log error
      developer.log(
        "AsksRespository create() error",
        error: e,
      );

      return (false, errorsMap);
    }
  }

  /// Queries on the [Ask] collection to update the record corresponding
  /// to information in the [map] parameter.
  ///
  /// Returns (true, {}) if updated successfully, else false
  /// and a map of the errors.
  Future<(bool, Map)> update(Map map) async {
    try {
      // Update Ask
      await pb.collection(Collection.asks).update(
        map[GenericField.id],
        body: {
          AskField.boon: map[AskField.boon],
          AskField.currency: map[AskField.currency],
          AskField.description: map[AskField.description],
          AskField.deadlineDate: map[AskField.deadlineDate],
          AskField.instructions: map[AskField.instructions],
          AskField.targetSum: map[AskField.targetSum],
          AskField.targetMetDate: map[AskField.targetMetDate],
          AskField.type: map[AskField.type]
        }
      );

      // Return
      return (true, {});
    } on ClientException catch(e) {
      var errorsMap = getErrorsMapFromClientException(e);

      // Log error
      developer.log(
        "AsksRespository update() error",
        error: e,
      );

      return (false, errorsMap);
    }
  }

  /// Queries on the [Ask] collection to delete the record corresponding
  /// to information in the [map] parameter.
  ///
  /// Returns (true, {}) if deleted successfully, else false
  /// and a map of the errors.
  Future<(bool, Map)> delete(Map map) async {
    try {
      // Delete Ask
      await pb.collection(Collection.asks).delete(map[GenericField.id]);

      return (true, {});
    } on ClientException catch(e) {
      // Log error
      developer.log(
        "AsksRespository delete() error",
        error: e,
      );

      return (false, {});
    }
  }

  /// Subscribes to any changes made in the [Ask] collection for any [Ask] record
  /// associated with the given [gardenID].
  ///
  /// Calls the given [callback] method whenever a change is made.
  Future<Function> subscribeTo(String gardenID, Function callback) {
    Future<Function> unsubscribeFunc = pb.collection(Collection.asks)
      .subscribe(Subscribe.all, (e) async {
        if (e.record?.data[AskField.garden] != gardenID) return;

        switch (e.action) {
          case EventAction.create:
          case EventAction.update:
          case EventAction.delete:
            callback();
        }
      });

    return unsubscribeFunc;
  }
}