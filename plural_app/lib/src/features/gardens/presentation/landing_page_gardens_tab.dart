import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_api.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';
import 'package:plural_app/src/features/gardens/presentation/listed_garden_tile.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class LandingPageGardensTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = GetIt.instance<AppState>();

    return Column(
      children: [
        FutureBuilder<List<Garden>>(
          future: getGardensByUser(appState.currentUserID!, excludesCurrentGarden: false),
          builder: (BuildContext context, AsyncSnapshot<List<Garden>> snapshot) {
            if (snapshot.hasData) {
              return LandingPageGardensList(gardens: snapshot.data!);
            } else if (snapshot.hasError) {
              return LandingPageGardensListError(error: snapshot.error);
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
    required this.gardens,
  });

  final List<Garden> gardens;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(AppPaddings.p35),
        children: [
          for (Garden garden in gardens) LandingPageListedGardenTile(garden: garden)
        ],
      ),
    );
  }
}

class LandingPageGardensListError extends StatelessWidget {
  const LandingPageGardensListError({
    this.error,
  });

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(child: Text("$error")),
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