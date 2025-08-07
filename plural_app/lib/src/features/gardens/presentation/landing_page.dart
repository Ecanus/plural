import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/presentation/landing_page_settings_tab.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_api.dart';
import 'package:plural_app/src/features/gardens/presentation/landing_page_gardens_tab.dart';

// Invitations
import 'package:plural_app/src/features/invitations/presentation/landing_page_invitations_tab.dart';

// Localization
import 'package:plural_app/src/utils/app_state.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({
    required this.exitedGardenID,
  });

  final String? exitedGardenID;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _canQueryGardens = false;
  late List<Tab> _tabs;

  @override
  void initState() {
    super.initState();
    final appState = GetIt.instance<AppState>();

    // exitedGardenID handling
    if (widget.exitedGardenID == null) {
      setState(() => _canQueryGardens = true);
    } else {
      // LandingPageGardensTab() should not display until the currentUser
      // has been successfully removed from the Garden matching exitedGardenID
      removeUserFromGarden(
        appState.currentUser!.id,
        widget.exitedGardenID!,
        () => setState(() => _canQueryGardens = true)
      );
    }

    _tabs = <Tab>[
      Tab(icon: Icon(Icons.local_florist)),
      Tab(icon: Icon(Icons.mail)),
      Tab(icon: Icon(Icons.settings)),
    ];

    // Subscribe to UserSettings
    subscribeToUserSettings();

    // Always set currentGarden to null
    // and clear garden-specific database subscriptions when loading this page
    GetIt.instance<AppState>().clearGardenAndSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints.expand(
            width: AppConstraints.c600,
            height: AppConstraints.c700,
          ),
          child: DefaultTabController(
            length: _tabs.length,
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(tabs: _tabs),
              ),
              body: TabBarView(
                children: [
                  _canQueryGardens ?
                    LandingPageGardensTab()
                    : BlankLandingPageGardensTab(),
                  LandingPageInvitationsTab(),
                  LandingPageSettingsTab(),
                ]
              ),
            )
          ),
        ),
      ),
    );
  }
}