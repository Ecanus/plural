// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

class AppUserGardenRecord {
  AppUserGardenRecord({
    required this.uid,
    required this.user,
    required this.garden,
  });

  final String uid;
  final AppUser user;
  final Garden garden;
}