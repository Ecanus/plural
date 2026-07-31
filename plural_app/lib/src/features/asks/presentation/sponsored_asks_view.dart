import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

// Common Functions
import 'package:plural_app/src/common_functions/app_responsiveness.dart';

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
import 'package:plural_app/src/features/asks/presentation/sponsored_ask_tile.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/route_to_view_button.dart';

class SponsoredAsksView extends StatefulWidget {
  @override
  State<SponsoredAsksView> createState() => _SponsoredAsksViewState();
}

class _SponsoredAsksViewState extends State<SponsoredAsksView> {
  late Future<List<Ask>> _asks;

  final appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

  final datetimeNow = DateTime.parse(
    DateFormat(Formats.dateYMMddHHms).format(DateTime.now())).toLocal();

  @override
  void initState() {
    super.initState();

    _asks = getAsksForSponsoredAsksView(now: datetimeNow);
  }

  @override
  Widget build(BuildContext context) {
    final appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

    return Column(
      children: [
        FutureBuilder<List<Ask>>(
          future: _asks,
          builder: (BuildContext context, AsyncSnapshot<List<Ask>> snapshot) {
            final done = snapshot.connectionState == ConnectionState.done;

            if (done && snapshot.hasData) {
              return SponsoredAsksViewList(
                sponsoredAskTiles: [
                  for (Ask ask in snapshot.data!) SponsoredAskTile(ask: ask)
                ],
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
              icon: Icons.toc_rounded,
              message: AskViewText.goToListedAsks,
              callback: appDialogViewRouter.routeToListedAsksView,
            ),
            RouteToViewButton(
              icon: Icons.add,
              message: AskViewText.createAsk,
              callback: appDialogViewRouter.routeToCreateAskView
            ),
          ],
        ),
        AppDialogNavFooter(
          leftDialogIcon: Icons.local_florist,
          leftNavCallback: appDialogViewRouter.routeToCurrentGardenSettingsView,
          leftTooltipMessage: AppDialogFooterText.navToCurrentGardenSettingsView,
          rightDialogIcon: Icons.settings,
          rightNavCallback: appDialogViewRouter.routeToUserSettingsView,
          rightTooltipMessage: AppDialogFooterText.navToSettingsView,
          title: getResponsiveUiValue(
            context, ResponsiveUiKeys.sponsoredAsksViewNavFooterTitle)
        )
      ],
    );
  }
}

class SponsoredAsksViewList extends StatelessWidget {
  const SponsoredAsksViewList({
    required this.sponsoredAskTiles,
  });

  final List<SponsoredAskTile> sponsoredAskTiles;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: sponsoredAskTiles.isEmpty ?
        EmptySponsoredAsksViewMessage() :
        ListView(
          padding: const EdgeInsets.all(AppPaddings.p35),
          children: sponsoredAskTiles,
        ),
    );
  }
}

class EmptySponsoredAsksViewMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AskViewText.emptySponsoredAsksView,
            style: Theme.of(context).textTheme.headlineSmall
          ),
          gapH25,
          Text(
            AskViewText.emptySponsoredAsksViewSubtitle,
            style: Theme.of(context).textTheme.bodyMedium
          ),
        ],
      ),
    );
  }
}