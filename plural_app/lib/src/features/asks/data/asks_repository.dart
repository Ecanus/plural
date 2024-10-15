import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/strings.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';

class AsksRepository {
  AsksRepository({
    required this.pb,
  });

  final PocketBase pb;

  // Method that queries on the asks collection to retrieve records
  // by corresponding params.
  //[deserialize], if true, converts retrieved records into Ask instances.
  Future get({bool deserialize = true}) async {
    var result = await pb.collection(Collection.asks).getList(
      sort: "created"
    );

    if (deserialize) return await Ask.createInstancesFromQuery(result);

    return result;
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

}