import 'package:pocketbase/pocketbase.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/strings.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden_manager.dart';

class AsksRepository {
  AsksRepository({
    required this.pb,
  });

  final PocketBase pb;

  /// Queries on the [Ask] collection to retrieve records in the database
  /// with values matching the [filterString].
  ///
  /// Returns the list of retrieved [Ask]s.
  Future<List<Ask>> get({
    int? count,
    String filterString = "",
    String sortString = "created",
    }) async {
      var currentGardenID = GetIt.instance<GardenManager>().currentGarden!.id;
      filterString = filterString == "" ? "garden = '$currentGardenID'" : filterString;

      var result = await pb.collection(Collection.asks).getList(
        filter: filterString,
        sort: sortString
      );

      return await Ask.createInstancesFromQuery(result, count: count);
  }

  /// Queries on the [Ask] collection to retrieve all records corresponding
  /// to the given [userID] and the current [Garden].
  ///
  /// Returns the list of retrieved [Ask]s
  Future<List<Ask>> getAsksByUserID({String? userID}) async {
    final currentGarden = GetIt.instance<GardenManager>().currentGarden!;

    userID = userID ?? GetIt.instance<AuthRepository>().getCurrentUserID();

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
        AskField.description: map[AskField.description],
        AskField.deadlineDate: map[AskField.deadlineDate],
        AskField.targetDonationSum: map[AskField.targetDonationSum],
        AskField.fullySponsoredDate: map[AskField.fullySponsoredDate]
      }
    );
  }

  /// Queries on the [Ask] collection to create a record corresponding
  /// to information in the [map] parameter.
  Future<void> create(Map map) async {
    await pb.collection(Collection.asks).create(
      body: {
        AskField.creator: GetIt.instance<AuthRepository>().getCurrentUserID(),
        AskField.description: map[AskField.description],
        AskField.deadlineDate: map[AskField.deadlineDate],
        AskField.targetDonationSum: map[AskField.targetDonationSum],
        AskField.garden: GetIt.instance<GardenManager>().currentGarden!.id,
      }
    );
  }
}