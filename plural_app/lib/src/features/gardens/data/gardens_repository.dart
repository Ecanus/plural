import 'dart:developer' as developer;

import 'package:plural_app/src/features/gardens/data/gardens_api.dart';
import 'package:plural_app/src/utils/exceptions.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:get_it/get_it.dart';

// Common Interfaces
import 'package:plural_app/src/common_interfaces/repository.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class GardensRepository implements Repository {
  GardensRepository({
    required this.pb,
  });

  final PocketBase pb;
  final _collection = Collection.gardens;

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
        "$runtimeType.bulkDelete(),"
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
   throw UnimplementedError();
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
        "$runtimeType.delete(),"
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
        "$runtimeType.getFirstListItem(),"
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
        "$runtimeType.getList(),"
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

  /// Subscribes to any changes made in the [Garden] collection for
  /// the [Garden] record with the corresponding [gardenID].
  ///
  /// Updates the value of [AppState] currentGarden whenever a change is made.
  Future<Function> subscribe(String gardenID) async {
    return pb.collection(_collection).subscribe(
      gardenID, (e) async {
        switch (e.action) {
          case EventAction.update:
            GetIt.instance<AppState>().currentGarden = await getGardenByID(gardenID);
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