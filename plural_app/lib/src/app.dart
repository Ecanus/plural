import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/ask_dialog.dart';

// Garden
import 'package:plural_app/src/features/gardens/presentation/garden_header.dart';
import 'package:plural_app/src/features/gardens/presentation/garden_timeline.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/values.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Plural App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        home: AppHomePage(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {

}

class AppHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            gapH60,
            Row(
              children: [
                flex2,
                GardenHeader(),
                flex2,
              ],
            ),
            gapH30,
            Expanded(
              child: Row(
                children: [GardenTimeline()],
              )
            ),
            Row(
              children: [Expanded(child: AppFooter())],
            ),
            gapH35
          ],
        ),
      ),
    );
  }
}

/// Parent Widget of the AppBottomBar and all widgets
/// at the bottom of the App.
class AppFooter extends StatelessWidget {
  final ValueNotifier<bool> _isFooterCollapsed = ValueNotifier<bool>(true);

  final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.onPrimaryColor,
    elevation: AppElevations.e5,
    iconColor: AppColors.secondaryColor,
    padding: EdgeInsets.all(AppPaddings.p18),
    shape: CircleBorder(),
  );

  bool toggleIsFooterCollapsed () {
    return _isFooterCollapsed.value = !_isFooterCollapsed.value;
  }

  @override
  Widget build(BuildContext context) {
    final showActionsButton = ElevatedButton(
      style: buttonStyle,
      onPressed: toggleIsFooterCollapsed,
      child: Icon(Icons.add, size: AppIconSizes.s30),
    );

    final hideActionsButton = ElevatedButton(
      style: buttonStyle,
      onPressed: toggleIsFooterCollapsed,
      child: Icon(Icons.close, size: AppIconSizes.s30),
    );

    return ValueListenableBuilder(
      valueListenable: _isFooterCollapsed,
      builder: (BuildContext context, bool value, Widget? child) {
        return value ?
          Center(child: showActionsButton) :
          AppBottomBar(hideActionsButton: hideActionsButton,);
      }
    );
  }
}

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.hideActionsButton
  });

  final Widget hideActionsButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.none,
        children: [
          Container(
            constraints: BoxConstraints.expand(
              width: AppConstraints.c350,
              height: AppConstraints.c50
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadii.r50),
              color: AppColors.darkGrey1,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                gapW10,
                IconButton(
                  color: AppColors.secondaryColor,
                  icon: const Icon(Icons.library_add),
                  iconSize: AppButtonSizes.s31,
                  tooltip: Strings.tooltipAddAsk,
                  // onPressed: () => createAskDialogBuilder(context),
                  onPressed: null,
                ),
                IconButton(
                  color: AppColors.secondaryColor,
                  icon: const Icon(Icons.settings),
                  iconSize: AppButtonSizes.s31,
                  tooltip: Strings.tooltipSettings,
                  onPressed: () {},
                ),
                IconButton(
                  color: AppColors.secondaryColor,
                  icon: const Icon(Icons.mail),
                  iconSize: AppButtonSizes.s31,
                  tooltip: Strings.tooltipInvitations,
                  onPressed: () {},
                ),
                IconButton(
                  color: AppColors.secondaryColor,
                  icon: const Icon(Icons.grass),
                  iconSize: AppButtonSizes.s31,
                  tooltip: Strings.tooltipAddGarden,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Positioned(
            left: AppPositions.pNeg10,
            child: hideActionsButton,
          ),
        ],
      ),
    );
  }
}