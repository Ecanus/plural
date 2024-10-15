// Pocketbase
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/strings.dart';

// Auth
import "package:plural_app/src/features/authentication/domain/app_user.dart";

class AuthRepository {
  AuthRepository({
    required this.pb
  });

  final PocketBase pb;

  AppUser? _currentUser;

  String getCurrentUserUID() {
    return pb.authStore.model.id;
  }

  AppUser getCurrentUser() {
    var user = pb.authStore.model;
    user = user.toJson();

    // TODO: Raise error if user is null

    // Cache currentUser if currentUser is null
    if (_currentUser == null) {
      var currentUser = AppUser(
        uid: user["id"],
        email: user["email"],
        firstName: user["firstName"],
        lastName: user["lastName"]
      );

      _currentUser = currentUser;
    }

    return _currentUser!;
  }

  Future<AppUser> getUserByUID(String uid) async {
    var result = await pb.collection(Collection.users).getFirstListItem(
      'id = "$uid"'
    );

    // TODO: Raise error if result is empty

    var record = result.toJson();

    return AppUser(
      uid: record["id"],
      email: record[UserField.email],
      firstName: record[UserField.firstName],
      lastName: record[UserField.lastName]
    );
  }
}