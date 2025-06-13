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

class UserSettingsRepository implements Repository {
  UserSettingsRepository({
    required this.pb,
  });

  final PocketBase pb;
  final _collection = Collection.userSettings;

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

  /// Subscribes to any changes made in the [UserSettings] collection to the
  /// [UserSettings] record stored in [AppState].currentUserSettings.
  ///
  /// Updates the [AppState]'s currentUserSettings whenever a change is made.
  Future<Function> subscribe() {
    return pb.collection(_collection).subscribe(
      Subscribe.all, (e) async {
        final currentUserSettings = GetIt.instance<AppState>().currentUserSettings!;
        final hasIDMatch = currentUserSettings.user.id == pb.authStore.record?.id;

        if (!hasIDMatch) return;

        switch (e.action) {
          case EventAction.update:
            GetIt.instance<AppState>().currentUserSettings = await getCurrentUserSettings();
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