import 'dart:developer' as developer;

import 'package:pocketbase/pocketbase.dart';

// Common Interfaces
import 'package:plural_app/src/common_interfaces/repository.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

class UserGardenRecordsRepository implements Repository {
  UserGardenRecordsRepository({
    required this.pb,
  });

  final PocketBase pb;
  final _collection = Collection.userGardenRecords;

  @override
  Future<void> bulkDelete({
    required ResultList records,
  }) async {
    try {
      for (final record in records.items) {
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
  Future<RecordModel?> getFirstListItem({
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

      return null;
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

  @override
  Future<RecordModel> update({
    required String id,
    Map<String, dynamic> body = const {},
  }) async {
    try {
      return await pb.collection(_collection).update(
        id,
        body: body
      );
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

      rethrow;
    }
  }
}