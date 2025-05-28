import 'package:get_it/get_it.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

/// Returns a list of [Garden] instances corresponding to [Garden] records from the
/// database that the given [userID] belongs to.
///
/// If [excludeCurrentGarden] is true, the [Garden] corresponding
/// to [AppState].currentGarden will be excluded from the list of results.
Future<List<Garden>> getGardensByUser(
  String userID, {
  bool excludeCurrentGarden = true,
}) async {
  List<Garden> gardens = [];
  var filter = "${UserGardenRecordField.user} = '$userID'";

  // excludeCurrentGarden
  if (excludeCurrentGarden) {
    final currentGardenID = GetIt.instance<AppState>().currentGarden!.id;
    filter = ""
      "${UserGardenRecordField.garden}.${GenericField.id} != '$currentGardenID' && "
      "$filter";
  }

  final query = await GetIt.instance<UserGardenRecordsRepository>().getList(
    expand: UserGardenRecordField.garden,
    filter: filter,
    sort: "garden.name",
  );

  for (final record in query.items) {
    final creator = await getUserByID(userID);
    final userGardenRecordJson =
      record.toJson()[QueryKey.expand][UserGardenRecordField.garden];

    final garden = Garden.fromJson(userGardenRecordJson, creator);
    gardens.add(garden);
  }

  return gardens;
}