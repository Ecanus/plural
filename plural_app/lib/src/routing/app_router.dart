import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/query_parameters.dart';
import 'package:plural_app/src/constants/routes.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/sign_in_page.dart';
import 'package:plural_app/src/features/authentication/presentation/unauthorized_page.dart';

// Garden
import 'package:plural_app/src/features/gardens/presentation/garden_page.dart';
import 'package:plural_app/src/features/gardens/presentation/landing_page.dart';

class AppRouter {
  AppRouter(PocketBase? database) {
    router = GoRouter(
      initialLocation: Routes.signIn,
      routes: [
        GoRoute(
          path: Routes.garden,
          builder: (_, __) => GardenPage()
        ),
        GoRoute(
          path: Routes.landing,
          builder: (_, state) => LandingPage(
            exitedGardenID: state.uri.queryParameters[QueryParameters.exitedGardenID],
          ),
        ),
        GoRoute(
          path: Routes.signIn,
          builder: (_, __) => SignInPage(
            database: database
          ),
        ),
        GoRoute(
          path: Routes.unauthorized,
          builder: (_, state) => UnauthorizedPage(
            previousRoute: state.uri.queryParameters[QueryParameters.previousRoute],
          )
        ),
      ]
    );
  }

  late GoRouter router;
}