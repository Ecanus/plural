import 'package:get_it/get_it.dart';

// Asks
import "package:plural_app/src/features/asks/data/asks_repository.dart";
import "package:plural_app/src/features/asks/domain/ask.dart";
import 'package:plural_app/src/features/asks/presentation/listed_ask_tile.dart';

Future<List<ListedAskTile>> getListedAskTilesByAsks () async {
  final asksRepository = GetIt.instance<AsksRepository>();
  final currentUserAsksList = await asksRepository.getAsksByUserID();

  return [for (Ask ask in currentUserAsksList) ListedAskTile(ask: ask)];
}