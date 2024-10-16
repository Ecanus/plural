import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/domain/ask_dialog_manager.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden_manager.dart';
import 'package:plural_app/src/features/gardens/domain/garden_timeline_notifier.dart';

void createGetItInstances() {
  final getIt = GetIt.instance;

  // Asks
  getIt.registerLazySingleton<AskDialogManager>(
    () => AskDialogManager()
  );

  // Gardens
  getIt.registerSingleton<GardenTimelineNotifier>(GardenTimelineNotifier());

  getIt.registerLazySingleton<GardenManager>(
    () => GardenManager(
      timelineNotifier: getIt<GardenTimelineNotifier>()
    )
  );
}

Future<void> logIn({
  required usernameOrEmail,
  required password
}) async {
  final getIt = GetIt.instance;

  // Database
  getIt.registerLazySingleton<PocketBase>(
    () => PocketBase("http://127.0.0.1:8090") // TODO: Change url dynamically by env
  );

  // Asks
  getIt.registerLazySingleton<AsksRepository>(
    () => AsksRepository(
      pb: getIt<PocketBase>(),
    )
  );

  // Auth
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      pb: getIt<PocketBase>(),
    )
  );

  // Log In
  await getIt<PocketBase>().collection(Collection.users).authWithPassword(
    usernameOrEmail, password);
}