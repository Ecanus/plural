import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_future_builder_error.dart';
import 'package:plural_app/src/common_widgets/app_future_builder_loading.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/formats.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_api.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/presentation/listed_ask_tile.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/route_to_view_button.dart';

class ListedAsksView extends StatefulWidget {

  @override
  State<ListedAsksView> createState() => _ListedAsksViewState();
}

class _ListedAsksViewState extends State<ListedAsksView> {
  late Future<List<Ask>> _asks;

  final appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

  final datetimeNow = DateTime.parse(
    DateFormat(Formats.dateYMMddHHms).format(DateTime.now())).toLocal();

  @override
  void initState() {
    super.initState();

    _asks = getAsksForListedAsksView(
      userID: GetIt.instance<AppState>().currentUserID!, now: datetimeNow);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<Ask>>(
          future: _asks,
          builder: (BuildContext context, AsyncSnapshot<List<Ask>> snapshot) {
            final done = snapshot.connectionState == ConnectionState.done;

            if (done && snapshot.hasData) {
              return ListedAsksViewList(
                listedAskTiles: [
                  for (Ask ask in snapshot.data!) ListedAskTile(ask: ask)
                ]
              );
            } else if (done && snapshot.hasError) {
              return AppFutureBuilderError(error: snapshot.error);
            } else {
              return AppFutureBuilderLoading();
            }
          }
        ),
        AppDialogFooterBuffer(
          buttons: [
            RouteToViewButton(
              icon: Icons.volunteer_activism,
              message: AskViewText.goToSponsoredAsks,
              callback: appDialogViewRouter.routeToSponsoredAsksView,
            ),
            RouteToViewButton(
              icon: Icons.add,
              message: AskViewText.createAsk,
              callback: appDialogViewRouter.routeToCreateAskView
            )
          ],
        ),
        AppDialogNavFooter(
          leftDialogIcon: Icons.local_florist,
          leftNavCallback: appDialogViewRouter.routeToCurrentGardenSettingsView,
          leftTooltipMessage: AppDialogFooterText.navToCurrentGardenSettingsView,
          rightDialogIcon: Icons.settings,
          rightNavCallback: appDialogViewRouter.routeToUserSettingsView,
          rightTooltipMessage: AppDialogFooterText.navToSettingsView,
          title: AppDialogFooterText.listedAsks
        )
      ],
    );
  }
}

class ListedAsksViewList extends StatelessWidget {
  const ListedAsksViewList({
    required this.listedAskTiles,
  });

  final List<ListedAskTile> listedAskTiles;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: listedAskTiles.isEmpty ?
        EmptyListedAsksViewMessage() :
        ListView(
          padding: const EdgeInsets.all(AppPaddings.p35),
          children: listedAskTiles,
        )
    );
  }
}

class EmptyListedAsksViewMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPaddings.p25
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AskViewText.emptyListedAsksView,
                  style: Theme.of(context).textTheme.headlineSmall
                ),
              ],
            ),
            gapH25,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    AskViewText.emptyListedAsksViewSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}