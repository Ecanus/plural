import 'package:pocketbase/pocketbase.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class GardensRepository {
  GardensRepository({
    required this.pb,
  });

  final PocketBase pb;

  /// Queries on the [Garden] collection to retrieve the record corresponding to the
  /// given [gardenID].
  ///
  /// Returns a [Garden] instance.
  Future<Garden> getGardenByID(String gardenID) async {
    final authRepository = GetIt.instance<AuthRepository>();

    var result = await pb.collection(Collection.gardens).getFirstListItem(
      "${GenericField.id} = '$gardenID'"
    );

    // TODO: Raise error if result is empty
    var record = result.toJson();
    var creator = await authRepository.getUserByID(record[GardenField.creator]);

    return Garden(
      id: record[GenericField.id],
      creator: creator,
      name: record[GardenField.name]
    );
  }

  /// Queries on the [UserGardenRecord] collection to retrieve all [Garden] records
  /// associated with the given [userID].
  ///
  /// Returns a list of [Garden] instances.
  Future<List<Garden>> getGardensByUser(String userID) async {
    List<Garden> instances = [];
    final authRepository = GetIt.instance<AuthRepository>();

    var result = await pb.collection(Collection.userGardenRecords).getList(
      expand: UserGardenRecordField.garden,
      filter: "${UserGardenRecordField.user} = '$userID'",
      sort: "garden.name",
    );

    // TODO: Raise error if result is empty
    var records = result.toJson()[QueryKey.items];

    // For each UserGarden record, create a Garden instance
    for (var record in records) {
      var recordGarden = record[QueryKey.expand][UserGardenRecordField.garden];
      var creator = await authRepository.getUserByID(recordGarden[GardenField.creator]);

      var garden = Garden(
        id: record[UserGardenRecordField.garden],
        creator: creator,
        name: recordGarden[GardenField.name],
      );

      instances.add(garden);
    }

    return instances;
  }

  /// Subscribes to any changes made in the [Garden] collection for
  /// the [Garden] record with the corresponding [gardenID].
  ///
  /// Updates the value of [AppState] currentGarden whenever a change is made.
  Future<Function> subscribeTo(String gardenID) {
    Future<Function> unsubscribeFunc = pb.collection(Collection.gardens)
      .subscribe(gardenID, (e) async {
        switch (e.action) {
          case EventAction.update:
            GetIt.instance<AppState>().currentGarden = await getGardenByID(gardenID);
        }
      });

    return unsubscribeFunc;
  }
}