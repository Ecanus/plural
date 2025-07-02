import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/user_settings_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

class MockAppDialogRouter extends Mock implements AppDialogViewRouter {}
class MockAppState extends Mock implements AppState {}
class MockAsksRepository extends Mock implements AsksRepository {}
class MockBuildContext extends Mock implements BuildContext {}
class MockGardensRepository extends Mock implements GardensRepository {}
class MockGoRouter extends Mock implements GoRouter {}
class MockPocketBase extends Mock implements PocketBase {}
class MockRecordService extends Mock implements RecordService {}
class MockUrlLauncher extends Mock with MockPlatformInterfaceMixin
  implements UrlLauncherPlatform {}
class MockUserGardenRecordsRepository extends Mock implements UserGardenRecordsRepository {}
class MockUserSettingsRepository extends Mock implements UserSettingsRepository {}
class MockUsersRepository extends Mock implements UsersRepository {}