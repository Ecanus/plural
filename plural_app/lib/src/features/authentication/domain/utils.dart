import 'package:get_it/get_it.dart';

// Auth
import "package:plural_app/src/features/authentication/data/auth_repository.dart";
import "package:plural_app/src/features/authentication/domain/app_user.dart";
import 'package:plural_app/src/features/authentication/presentation/listed_user_tile.dart';

Future<List<ListedUserTile>> getListedUserTilesByUsers() async {
  final authRepository = GetIt.instance<AuthRepository>();
  final currentGardenUsers = await authRepository.getCurrentGardenUsers();

  return [for (AppUser user in currentGardenUsers) ListedUserTile(user: user)];
}