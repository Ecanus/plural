import 'dart:developer' as developer;
import 'package:pocketbase/pocketbase.dart';
import 'package:get_it/get_it.dart';

// Common Methods
import 'package:plural_app/src/common_methods/errors.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/strings.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class AsksRepository {
  AsksRepository({
    required this.pb,
  });

  final PocketBase pb;

  /// Queries on the [Ask] collection to retrieve records in the database
  /// with values matching the [filterString].
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
      return await Ask.createInstancesFromQuery(result, count: count);
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

    return await Ask.createInstancesFromQuery(result);
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

  /// Appends the [User] record which corresponds to the given [userID] to the list
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
  /// Returns true and an empty map if created successfully, else false
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
  /// Returns true and an empty map if created successfully, else false
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
  /// Returns true and an empty map if created successfully, else false
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

  /// Subscribes to any changes made in the [Ask] collection to any [Ask] record
  /// associated with the [Garden] with the given [gardenID].
  ///
  /// Calls the given [callback] method whenever a change is made.
  Future<Function> subscribeTo(String gardenID, Function callback) {
    Future<Function> unsubscribeFunc = pb.collection(Collection.asks)
      .subscribe(Subscribe.all, (e) async {
        if (e.record?.data[AskField.garden] != gardenID) return;

        switch (e.action) {
          case EventAction.create:
            callback();
          case EventAction.update:
            callback();
          case EventAction.delete:
            callback();
        }
      });

    return unsubscribeFunc;
  }
}