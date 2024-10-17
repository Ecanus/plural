import 'package:pocketbase/pocketbase.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/strings.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

class AsksRepository {
  AsksRepository({
    required this.pb,
  });

  final PocketBase pb;

  /// Queries on the asks collection to retrieve corresponding records in
  /// the database.
  Future get({bool deserialize = true}) async {
    var result = await pb.collection(Collection.asks).getList(
      sort: "created"
    );

    if (deserialize) return await Ask.createInstancesFromQuery(result);

    return result;
  }

  Future<List<Ask>> getAsksByUserUID() async {
    final currentUserUID = GetIt.instance<AuthRepository>().getCurrentUserUID();

    var result = await pb.collection(Collection.asks).getList(
      sort: "created",
      filter: "creator = '$currentUserUID'"
    );

    return await Ask.createInstancesFromQuery(result);
  }

  /// Uses the given [map] parameter to update a corresponding Ask
  /// record in the database.
  Future update(Map map) async {
    await pb.collection(Collection.asks).update(
      map[AskField.uid],
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
  Future create(Map map) async {
    await pb.collection(Collection.asks).create(
      body: {
        AskField.creator: GetIt.instance<AuthRepository>().getCurrentUserUID(),
        AskField.description: map[AskField.description],
        AskField.deadlineDate: map[AskField.deadlineDate],
        AskField.targetDonationSum: map[AskField.targetDonationSum],
      }
    );
  }
}