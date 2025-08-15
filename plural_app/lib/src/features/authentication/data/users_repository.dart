import 'dart:developer' as developer;

import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Interfaces
import 'package:plural_app/src/common_interfaces/repository.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/exceptions.dart';

class UsersRepository implements Repository {
  UsersRepository({
    required this.pb,
  });

  final PocketBase pb;
  final _collection = Collection.users;

  Future<void> authWithPassword(
    String usernameOrEmail,
    String password
  ) async {
    try {
      await pb.collection(_collection).authWithPassword(
        usernameOrEmail, password);
    } on ClientException catch(e) {
      developer.log(
        ""
        "--\n"
        "$runtimeType.authWithPassword()"
        "\n"
        "usernameOrEmail: $usernameOrEmail"
        "\n"
        "password: $password",
        error: e,
      );

      rethrow;
    }
  }

  @override
  Future<void> bulkDelete({
    required ResultList resultList,
  }) async {
    try {
      for (final record in resultList.items) {
        await pb.collection(_collection).delete(record.toJson()[GenericField.id]);
      }
    } on ClientException catch(e) {
      developer.log(
        ""
        "--\n"
        "$runtimeType.bulkDelete()"
        "\n--",
        error: e,
      );

      rethrow;
    }
  }

  void clearAuthStore() {
    try {
      pb.authStore.clear();
    } on ClientException catch(e) {
       developer.log(
        ""
        "--\n"
        "$runtimeType.clearAuthStore()"
        "\n--",
        error: e,
      );

      rethrow;
    }
  }

  @override
  Future<(RecordModel?, Map)> create({
    required Map<String, dynamic> body
  }) async {
    try {
      final record = await pb.collection(_collection).create(body: body);
      return (record, {});
    } on ClientException catch(e) {
      developer.log(
        ""
        "--\n"
        "$runtimeType.create()"
        "\n--",
        error: e,
      );

      var errorsMap = getErrorsMapFromClientException(e);
      return (null, errorsMap);
    }
  }

  @override
  Future<void> delete({
    required String id,
  }) async {
    try {
      await pb.collection(_collection).delete(id);
    } on ClientException catch(e) {
      developer.log(
        ""
        "--\n"
        "$runtimeType.delete()"
        "\n"
        "id: $id"
        "\n--",
        error: e,
      );

      rethrow;
    }
  }

  @override
  Future<RecordModel> getFirstListItem({
    required String filter,
  }) async {
    try {
      return await pb.collection(_collection).getFirstListItem(filter);
    } on ClientException catch(e) {
      developer.log(
        ""
        "--\n"
        "$runtimeType.getFirstListItem()"
        "\n"
        "filter: $filter"
        "\n--",
        error: e,
      );

      rethrow;
    }
  }

  @override
  Future<ResultList> getList({
    String expand = "",
    String filter = "",
    String sort = "",
  }) async {
    try {
      return await pb.collection(_collection).getList(
        expand: expand,
        filter: filter,
        sort: sort,
      );
    } on ClientException catch(e) {
      developer.log(
        ""
        "--\n"
        "$runtimeType.getList()"
        "\n"
        "expand: $expand"
        "\n"
        "filter: $filter"
        "\n"
        "sort: $sort"
        "\n--",
        error: e,
      );

      rethrow;
    }
  }

  Future<void> requestPasswordReset(String email) async {
    try {
      pb.collection(_collection).requestPasswordReset(email);
    } on ClientException catch(e) {
      developer.log(
        ""
        "--\n"
        "$runtimeType.requestPasswordReset()"
        "\n"
        "email: $email"
        "\n--",
        error: e,
      );

      rethrow;
    }
  }

  Future<void> requestVerification(String email) async {
    try {
      await pb.collection(_collection).requestVerification(email);
    } on ClientException catch(e) {
      developer.log(
        ""
        "--\n"
        "$runtimeType.requestVerification()"
        "\n"
        "email: $email"
        "\n--",
        error: e,
      );

      rethrow;
    }
  }

  /// Subscribes to any changes made in the [User] collection for any [User] record
  /// associated with the given [gardenID].
  ///
  /// Calls the [callback] function whenever a change is made.
  Future<Function> subscribe(String gardenID, Function callback) async {
    return pb.collection(_collection).subscribe(
      Subscribe.all, (e) async {
        final userID = e.record!.toJson()[GenericField.id];

        // Only respond to changes to users in the given gardenID
        final gardenRecordRole = await getUserGardenRecordRole(
          userID: userID,
          gardenID: gardenID
        );

        if (gardenRecordRole == null) return;

        switch (e.action) {
          case EventAction.update:
            // Get new values from db, if currentUser was updated
            if (userID == GetIt.instance<AppState>().currentUserID!) {
              GetIt.instance<AppState>().currentUser = await getUserByID(userID);
            }
          case EventAction.create:
          case EventAction.delete:
            callback();
        }
      }
    );
  }

  Future<void> unsubscribe() async {
    try {
      await pb.collection(_collection).unsubscribe();
    } on ClientException catch(e) {
      developer.log(
        ""
        "--\n"
        "$runtimeType.unsubscribe()"
        "\n--",
        error: e,
      );

      rethrow;
    }
  }

  @override
  Future<(RecordModel?, Map)> update({
    required String id,
    Map<String, dynamic> body = const {},
  }) async {
    try {
      final record = await pb.collection(_collection).update(
        id,
        body: body
      );
      return (record, {});
    } on ClientException catch(e) {
      developer.log(
        ""
        "--\n"
        "$runtimeType.update()"
        "\n"
        "id: $id"
        "\n"
        "body: $body"
        "\n--",
        error: e,
      );

      var errorsMap = getErrorsMapFromClientException(e);
      return (null, errorsMap);
    }
  }
}