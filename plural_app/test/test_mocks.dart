import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import "package:mocktail/mocktail.dart";
import 'package:pocketbase/pocketbase.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockBuildContext extends Mock implements BuildContext {}
class MockGoRouter extends Mock implements GoRouter {}
class MockPocketBase extends Mock implements PocketBase {}
class MockRecordService extends Mock implements RecordService {}