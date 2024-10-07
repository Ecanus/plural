import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';

class AsksRepository {
  AsksRepository({
    required this.pb,
    required usernameOrEmail,
    required password
  }) {
    // Log In
    pb.collection(Collection.users).authWithPassword(
      usernameOrEmail, password);
  }

  final PocketBase pb;

  // static List<Ask> _fakeDB = [
  //   Ask(
  //     uid: "00001",
  //     creatorUID: "TESTUSER1",
  //     description: "Need help with groceries this week. Anything helps!",
  //     deadlineDate: DateTime(2025, 2, 3),
  //   ),
  //   Ask(
  //     uid: "00002",
  //     creatorUID: "TESTUSER1",
  //     description: "Buying a new piano finally! Pray for me lol",
  //     deadlineDate: DateTime(2025, 3, 29),
  //   ),
  //   Ask(
  //     uid: "00003",
  //     creatorUID: "TESTUSER1",
  //     description: "Trip to Japannnnnnn <3",
  //     deadlineDate: DateTime(2025, 4, 20),
  //   ),
  //   Ask(
  //     uid: "00004",
  //     creatorUID: "TESTUSER2",
  //     description: "Architecture school isn't cheap :'(",
  //     deadlineDate: DateTime(2025, 4, 25),
  //   ),
  //   Ask(
  //     uid: "00005",
  //     creatorUID: "TESTUSER2",
  //     description: "Need paint for some book covers and things >.<",
  //     deadlineDate: DateTime(2025, 6, 13),
  //   ),
  //   Ask(
  //     uid: "00006",
  //     creatorUID: "TESTUSER2",
  //     description: "Surprise party for my twin! All donations appreciated!",
  //     deadlineDate: DateTime(2025, 7, 8),
  //   ),
  //   Ask(
  //     uid: "00007",
  //     creatorUID: "TESTUSER3",
  //     description: "I'm going to the US Open, so help me God",
  //     deadlineDate: DateTime(2025, 7, 24),
  //   ),
  //   Ask(
  //     uid: "00008",
  //     creatorUID: "TESTUSER3",
  //     description: "Flying back to Ghana to visit my mom",
  //     deadlineDate: DateTime(2025, 8, 31),
  //   ),
  //   Ask(
  //     uid: "00009",
  //     creatorUID: "TESTUSER3",
  //     description: "Wanna surprise my bestie with some gifts and things",
  //     deadlineDate: DateTime(2025, 10, 8),
  //   ),
  // ];

  // Add
  Future<void> addAsk({
    required String uid,
    required String creatorUID,
    required String description,
    required DateTime deadlineDate,
    int targetDonationSum = 0,
  }) async {
    // TODO: Implement
  }

  // Update
  Future<void> updateAsk({
    required Ask ask,
  }) async {
    // TODO: Implement
  }

  // method that queries on the asks collection to retrieve records
  // by corresponding params.
  //[deserialize], if true, converts retrieved records into Ask instances.
  Future get({bool deserialize = true}) async {
    var result = await pb.collection(Collection.asks).getList(
      sort: "created"
    );

    if (deserialize) return await Ask.createInstancesFromQuery(result);

    return result;
  }

}