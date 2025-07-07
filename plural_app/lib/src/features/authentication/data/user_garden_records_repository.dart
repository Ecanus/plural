import 'dart:developer' as developer;

import 'package:pocketbase/pocketbase.dart';

// Common Interfaces
import 'package:plural_app/src/common_interfaces/repository.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Utils
import 'package:plural_app/src/utils/exceptions.dart';

class UserGardenRecordsRepository implements Repository {
  UserGardenRecordsRepository({
    required this.pb,
  });

  final PocketBase pb;
  final _collection = Collection.userGardenRecords;

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

  /// Subscribes to any changes made in the [UserGardenRecord] collection for any
  /// [UserGardenRecord] record associated with the given [gardenID].
  ///
  /// Calls the [callback] function whenever a change is made.
  Future<Function> subscribe(String gardenID, Function callback) async {
    return pb.collection(_collection).subscribe(
      Subscribe.all, (e) async {
        final userGardenRecordGardenID = e.record!.toJson()[UserGardenRecordField.garden];

        if (userGardenRecordGardenID != gardenID) return;

        switch (e.action) {
          case EventAction.create:
          case EventAction.delete:
          case EventAction.update:
            callback();
        }
      });
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