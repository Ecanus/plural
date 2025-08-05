import 'dart:developer' as developer;

import 'package:pocketbase/pocketbase.dart';

// Common Interfaces
import 'package:plural_app/src/common_interfaces/repository.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';

// Utils
import 'package:plural_app/src/utils/exceptions.dart';

class InvitationsRepository implements Repository {
  InvitationsRepository({
    required this.pb,
  });

  final PocketBase pb;
  final _collection = Collection.invitations;

  @override
  Future<void> bulkDelete({
    required ResultList<Jsonable> resultList
  }) async {
    throw UnimplementedError();
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
    throw UnimplementedError();
  }

  @override
  Future<RecordModel> getFirstListItem({
    required String filter,
  }) async {
    throw UnimplementedError();
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

  @override
  Future<(RecordModel?, Map)> update({
    required String id,
    Map<String, dynamic> body = const {},
  }) async {
    throw UnimplementedError();
  }
}