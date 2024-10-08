// Pocketbase
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';

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
    var result = await pb.collection(Collection.users).getList(
      filter: 'id = "$uid"'
    );

    // TODO: Raise error if result is empty

    var record = result.toJson()["items"][0];

    return AppUser(
      uid: record["id"],
      email: record["email"],
      firstName: record["firstName"],
      lastName: record["lastName"]
    );
  }
}