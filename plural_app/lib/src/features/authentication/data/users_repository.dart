import 'package:plural_app/src/common_interfaces/repository.dart';

// Pocketbase
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';

class UsersRepository implements Repository {
  UsersRepository({
    required this.pb,
  });

  final PocketBase pb;
  final _collection = Collection.users;

  @override
  Future<RecordModel> getFirstListItem({
    required String filter,
  }) async {
    return await pb.collection(_collection).getFirstListItem(filter);
  }

  @override
  Future<ResultList> getList({
    String expand = "",
    String filter = "",
    String sort = "",
  }) async {
    return await pb.collection(_collection).getList(
      expand: expand,
      filter: filter,
      sort: sort,
    );
  }
}