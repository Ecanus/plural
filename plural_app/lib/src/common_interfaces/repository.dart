import 'package:pocketbase/pocketbase.dart';

abstract class Repository {
  Future<void> bulkDelete({
    required ResultList records,
  });

  Future<void> delete({
    required String id,
  });

  Future<RecordModel?> getFirstListItem({
    required String filter,
  });

  Future<ResultList> getList({
    String expand = "",
    String filter = "",
    String sort = "",
  });

  Future<RecordModel> update({
    required String id,
    Map<String, dynamic> body = const {},
  });
}