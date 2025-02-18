import 'package:get_it/get_it.dart';

// Auth
import "package:plural_app/src/features/authentication/domain/app_user.dart";

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_garden_tile.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

Future<List<ListedGardenTile>> getListedGardenTilesByUser(
  { AppUser? user}
) async {
  final gardensRepository = GetIt.instance<GardensRepository>();
  user = user ?? GetIt.instance<AppState>().currentUser!;
  final gardens = await gardensRepository.getGardensByUser(user: user);

  return [for (Garden garden in gardens) ListedGardenTile(garden: garden)];
}