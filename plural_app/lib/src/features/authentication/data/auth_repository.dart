// Pocketbase
import 'package:pocketbase/pocketbase.dart';

// Authentication
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

class AuthRepository {
  final pb = PocketBase("http://127.0.0.1:8090/");

  static List<AppUser> _fakeDB = [
    AppUser(
      uid: "PLURALTESTUSER1",
      email: "user1@test.com",
      password: "pickles1",
      firstName: "Test",
      lastName: "User1"
    ),
    AppUser(
      uid: "TESTUSER2",
      email: "user2@test.com",
      password: "pickles2",
      firstName: "Test",
      lastName: "User2"
    ),
    AppUser(
      uid: "TESTUSER2",
      email: "user3@test.com",
      password: "pickles3",
      firstName: "Yaa",
      lastName: "Owusu"
    ),
  ];

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

  // Get
  static AppUser? getUserByUID({required String uid}) {
    for(final AppUser user in _fakeDB) {
      if (user.uid == uid) return user;
    }

    return null;
  }
}