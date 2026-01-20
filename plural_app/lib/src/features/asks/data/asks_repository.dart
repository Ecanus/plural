import 'dart:developer' as developer;

import 'package:pocketbase/pocketbase.dart';

// Common Interfaces
import 'package:plural_app/src/common_interfaces/repository.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_api.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Utils
import 'package:plural_app/src/utils/exceptions.dart';

class AsksRepository implements Repository {
  AsksRepository({
    required this.pb,
  });

  final PocketBase pb;
  final _collection = Collection.asks;

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
        "$runtimeType.bulkDelete(), "
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
      final boon = body[AskField.boon];
      final currency = body[AskField.currency];
      String description = body[AskField.description];
      final targetSum = body[AskField.targetSum];

      // Validate boon < targetSum
      checkBoonCeiling(boon, targetSum);

      // If description == "", set description to targetSum
      body[AskField.description] = description.isEmpty ?
        "$targetSum $currency" : description;

      final record = await pb.collection(_collection).create(body: body);
      return (record, {});
    } on ClientException catch(e) {
      developer.log(
        ""
        "--\n"
        "$runtimeType.create(), "
        "\n--",
        error: e,
      );

      return (null, getErrorsMapFromClientException(e));
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
        "$runtimeType.delete(), "
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
        "$runtimeType.getFirstListItem(), "
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
        "$runtimeType.getList(), "
        "expand: $expand, "
        "filter: $filter, "
        "sort: $sort, "
        "\n--",
        error: e,
      );

      rethrow;
    }
  }

  /// Subscribes to any changes made in the [Ask] collection for any [Ask] record
  /// associated with [gardenID].
  ///
  /// Calls the given [callback] method whenever a change is made.
  Future<Function> subscribe(String gardenID, Function callback) async {
    return pb.collection(_collection).subscribe(
      Subscribe.all, (e) async {
        if (e.record?.data[AskField.garden] != gardenID) return;

        switch (e.action) {
          case EventAction.create:
          case EventAction.update:
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
        "$runtimeType.unsubscribe(), "
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
      final boon = body[AskField.boon];
      final targetSum = body[AskField.targetSum];

      if (boon != null && targetSum != null) checkBoonCeiling(boon, targetSum);

      final record = await pb.collection(_collection).update(
        id,
        body: body
      );
      return (record, {});
    } on ClientException catch(e) {
      developer.log(
        ""
        "--\n"
        "$runtimeType.update(), "
        "id: $id, "
        "body: $body, "
        "\n--",
        error: e,
      );

      return (null, getErrorsMapFromClientException(e));
    }
  }
}