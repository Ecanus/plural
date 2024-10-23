import 'package:plural_app/src/constants/strings.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

class GardensRepository {
  GardensRepository({
    required this.pb,
  });

  final PocketBase pb;

  Future<Garden> getGardenByUID(String uid) async {
    var result = await pb.collection(Collection.gardens).getFirstListItem(
      "${Field.id} = '$uid'"
    );

    // TODO: Raise error if result is empty
    var record = result.toJson();

    return Garden(
      uid: record[Field.id],
      name: record[GardenField.name]
    );
  }

  Future<List<Garden>> getGardensByUser({required AppUser user}) async {
    List<Garden> instances = [];

    var result = await pb.collection(Collection.userGardenRecords).getList(
      expand: UserGardenRecordField.garden,
      filter: "${UserGardenRecordField.user} = '${user.uid}'",
      sort: "garden.name",
    );

    // TODO: Raise error if result is empty
    var records = result.toJson()[PBKey.items];

    for (var record in records) {
      var recordGarden = record[PBKey.expand][UserGardenRecordField.garden];

      var garden = Garden(
        uid: record[UserGardenRecordField.gardenUID],
        name: recordGarden[GardenField.name],
      );

      instances.add(garden);
    }

    return instances;
  }
}