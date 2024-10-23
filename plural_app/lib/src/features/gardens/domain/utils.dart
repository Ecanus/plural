import 'package:get_it/get_it.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';
import "package:plural_app/src/features/authentication/domain/app_user.dart";

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_garden_tile.dart';

Future<List<ListedGardenTile>> getListedGardenTilesByUser(
  { AppUser? user}
) async {
  final authRepository = GetIt.instance<AuthRepository>();
  final gardensRepository = GetIt.instance<GardensRepository>();

  user = user ?? authRepository.currentUser!;

  final gardens = await gardensRepository.getGardensByUser(user: user);

  return [for (Garden garden in gardens) ListedGardenTile(garden: garden)];
}