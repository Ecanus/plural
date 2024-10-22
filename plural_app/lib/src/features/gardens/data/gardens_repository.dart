import 'package:plural_app/src/constants/strings.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

class GardensRepository {
  GardensRepository({
    required this.pb,
  });

  final PocketBase pb;

  Future<Garden> getGardenByUID(String uid) async {
    var result = await pb.collection(Collection.gardens).getFirstListItem(
      "id = '$uid'"
    );

    // TODO: Raise error if result is empty

    var record = result.toJson();

    return Garden(
      uid: record[Field.id],
      name: record[GardenField.name]
    );
  }
}