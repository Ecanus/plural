import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import "package:mocktail/mocktail.dart";
import 'package:pocketbase/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';

class MockAppDialogRouter extends Mock implements AppDialogRouter {}
class MockAsksRepository extends Mock implements AsksRepository {}
class MockAuthRepository extends Mock implements AuthRepository {}
class MockBuildContext extends Mock implements BuildContext {}
class MockGardensRepository extends Mock implements GardensRepository {}
class MockGoRouter extends Mock implements GoRouter {}
class MockPocketBase extends Mock implements PocketBase {}
class MockRecordService extends Mock implements RecordService {}