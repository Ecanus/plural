import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';

class AsksRepository {
  AsksRepository({
    required this.pb,
  });

  final PocketBase pb;

  // Method that queries on the asks collection to retrieve records
  // by corresponding params.
  //[deserialize], if true, converts retrieved records into Ask instances.
  Future get({bool deserialize = true}) async {
    var result = await pb.collection(Collection.asks).getList(
      sort: "created"
    );

    if (deserialize) return await Ask.createInstancesFromQuery(result);

    return result;
  }

}