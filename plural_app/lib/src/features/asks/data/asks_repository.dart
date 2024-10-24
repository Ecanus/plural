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

  /// Queries on the asks collection to retrieve corresponding records in
  /// the database.
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

  Future<List<Ask>> getAsksByUserID() async {
    final currentUserID = GetIt.instance<AuthRepository>().getCurrentUserID();
    final currentGarden = GetIt.instance<GardenManager>().currentGarden!;

    var result = await pb.collection(Collection.asks).getList(
      sort: Field.created,
      filter: """
          ${AskField.creator} = '$currentUserID' &&
          ${AskField.garden} = '${currentGarden.id}'
          """
    );

    return await Ask.createInstancesFromQuery(result);
  }

  /// Uses the given [map] parameter to update a corresponding Ask
  /// record in the database.
  Future update(Map map) async {
    await pb.collection(Collection.asks).update(
      map[Field.id],
      body: {
        AskField.description: map[AskField.description],
        AskField.deadlineDate: map[AskField.deadlineDate],
        AskField.targetDonationSum: map[AskField.targetDonationSum],
        AskField.fullySponsoredDate: map[AskField.fullySponsoredDate]
      }
    );
  }

  /// Uses the given [map] parameter to create a corresponding Ask
  /// record in the database.
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