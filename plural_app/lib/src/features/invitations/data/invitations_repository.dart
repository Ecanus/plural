import 'package:pocketbase/pocketbase.dart';

// Common Interfaces
import 'package:plural_app/src/common_interfaces/repository.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';

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
   throw UnimplementedError();
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
    throw UnimplementedError();
  }

  @override
  Future<(RecordModel?, Map)> update({
    required String id,
    Map<String, dynamic> body = const {},
  }) async {
    throw UnimplementedError();
  }
}