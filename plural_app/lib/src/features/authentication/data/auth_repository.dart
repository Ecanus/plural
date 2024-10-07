// Pocketbase
import 'package:pocketbase/pocketbase.dart';

// Auth
import "package:plural_app/src/features/authentication/domain/app_user.dart";

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';

class AuthRepository {
  AuthRepository({
    required this.pb,
    required usernameOrEmail,
    required password
  }) {
      // Log In
      pb.collection(Collection.users).authWithPassword(
        usernameOrEmail, password);
  }

  final PocketBase pb;

  // static List<AppUser> _fakeDB = [
  //   AppUser(
  //     uid: "PLURALTESTUSER1",
  //     email: "user1@test.com",
  //     password: "pickles1",
  //     firstName: "Test",
  //     lastName: "User1"
  //   ),
  //   AppUser(
  //     uid: "TESTUSER2",
  //     email: "user2@test.com",
  //     password: "pickles2",
  //     firstName: "Test",
  //     lastName: "User2"
  //   ),
  //   AppUser(
  //     uid: "TESTUSER2",
  //     email: "user3@test.com",
  //     password: "pickles3",
  //     firstName: "Yaa",
  //     lastName: "Owusu"
  //   ),
  // ];

  // Sign-Up
  // Future<void> signUp({
  //   required uid,
  //   required email,
  //   required password,
  //   required firstName,
  //   required lastName,
  // }) async {
  //   final body = {
  //     "username": firstName + lastName,
  //     "name": firstName + " " + lastName,
  //     "email": email,
  //     "password": password,
  //     "passwordConfirm": password,
  //   };

  //   final record = await pb.collection("users").create(body: body);
  //   print(record);
  // }

  String getCurrentUserUID() {
    return pb.authStore.model.id;
  }

  AppUser getCurrentUser() {
    var user = pb.authStore.model;

    // TODO: Raise error if user is null

    user = user.toJson();

    return AppUser(
      uid: user["id"],
      email: user["email"],
      firstName: user["firstName"],
      lastName: user["lastName"]
    );
  }

  // Get
  // AppUser? getUserByUID({required String uid}) {
  //   for(final AppUser user in _fakeDB) {
  //     if (user.uid == uid) return user;
  //   }

  //   return null;
  // }
}