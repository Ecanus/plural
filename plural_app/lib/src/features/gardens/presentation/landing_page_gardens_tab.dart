import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/landing_page_listed_garden_tile.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class LandingPageGardensTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = GetIt.instance<AppState>();

    return Column(
      children: [
        FutureBuilder<List<AppUserGardenRecord>>(
          future: getUserGardenRecordsByUserID(appState.currentUserID!),
          builder: (
              BuildContext context,
              AsyncSnapshot<List<AppUserGardenRecord>> snapshot) {
            if (snapshot.hasData) {
              return LandingPageGardensList(userGardenRecords: snapshot.data!);
            } else if (snapshot.hasError) {
              return LandingPageGardensListError(
                error: snapshot.error, stackTrace: snapshot.stackTrace);
            } else {
              return LandingPageGardensListLoading();
            }
          }
        ),
      ]
    );
  }
}

class LandingPageGardensList extends StatelessWidget {
  const LandingPageGardensList({
    required this.userGardenRecords,
  });

  final List<AppUserGardenRecord> userGardenRecords;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: userGardenRecords.isEmpty ?
        EmptyLandingPageGardensListMessage() :
        ListView(
          padding: const EdgeInsets.all(AppPaddings.p35),
          children: [
            for (AppUserGardenRecord record in userGardenRecords)
              LandingPageListedGardenTile(garden: record.garden)
          ],
        ),
    );
  }
}

class EmptyLandingPageGardensListMessage extends StatelessWidget {
  const EmptyLandingPageGardensListMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LandingPageText.emptyLandingPageGardensListMessage,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      )
    );
  }
}

class LandingPageGardensListError extends StatelessWidget {
  const LandingPageGardensListError({
    this.error,
    this.stackTrace,
  });

  final Object? error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: ListView(
          children: [
            Text("$error \n\n ${stackTrace.toString()}"),
          ],
        )
      ),
    );
  }
}

class LandingPageGardensListLoading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SizedBox(
          width: AppWidths.w60,
          height: AppHeights.h60,
          child: CircularProgressIndicator()
        ),
      ),
    );
  }
}

class BlankLandingPageGardensTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LandingPageGardensListLoading()
      ]
    );
  }
}