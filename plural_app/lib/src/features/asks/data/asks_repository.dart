import 'package:pocketbase/pocketbase.dart';
import 'package:get_it/get_it.dart';

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
      filterString = filterString == "" ? "garden = '$gardenID'" : filterString;

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
      sort: GenericField.created,
      filter: """
          ${AskField.creator} = '$userID' &&
          ${AskField.garden} = '${currentGarden.id}'
          """
    );

    return await Ask.createInstancesFromQuery(result);
  }

  /// Queries on the [Ask] collection to update the record corresponding
  /// to information in the [map] parameter.
  Future update(Map map) async {
    await pb.collection(Collection.asks).update(
      map[GenericField.id],
      body: {
        AskField.boon: map[AskField.boon],
        AskField.currency: map[AskField.currency],
        AskField.description: map[AskField.description],
        AskField.deadlineDate: map[AskField.deadlineDate],
        AskField.targetSum: map[AskField.targetSum],
        AskField.targetMetDate: map[AskField.targetMetDate],
        AskField.type: map[AskField.type]
      }
    );
  }

  /// Queries on the [Ask] collection to create a record corresponding
  /// to information in the [map] parameter.
  Future<void> create(Map map) async {
    var appState = GetIt.instance<AppState>();

    await pb.collection(Collection.asks).create(
      body: {
        AskField.boon: map[AskField.boon],
        AskField.creator: appState.currentUserID!,
        AskField.currency: map[AskField.currency],
        AskField.description: map[AskField.description],
        AskField.deadlineDate: map[AskField.deadlineDate],
        AskField.garden: appState.currentGarden!.id,
        AskField.targetSum: map[AskField.targetSum],
        AskField.type: map[AskField.type],
      }
    );
  }

  /// Subscribes to any changes made in the [Ask] collection to any [Ask] record
  /// associated to the [Garden] with the given [gardenID].
  ///
  /// Calls the given [callback] method whenever a change is made.
  Future<Function> subscribeTo(String gardenID, Function callback) {
    Future<Function> unsubscribeFunc = pb.collection(Collection.asks)
      .subscribe(Subscribe.all, (e) async {
        if (e.record?.data[AskField.garden] != gardenID) return;

        switch (e.action) {
          case EventAction.create:
            callback();
          case EventAction.delete:
            callback();
          case EventAction.update:
            callback();
        }
      });

    return unsubscribeFunc;
  }
}