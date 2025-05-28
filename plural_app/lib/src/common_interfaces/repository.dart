import 'package:pocketbase/pocketbase.dart';

abstract class Repository {
  Future<RecordModel> getFirstListItem({
    required String filter,
  });

  Future<ResultList> getList({
    String expand = "",
    String filter = "",
    String sort = "",
  });
}