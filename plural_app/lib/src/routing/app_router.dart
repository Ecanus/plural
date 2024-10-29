import 'package:go_router/go_router.dart';

// Constants
import 'package:plural_app/src/constants/routes.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/log_in_page.dart';

// Garden
import 'package:plural_app/src/features/gardens/presentation/garden_page.dart';

class AppRouter {
  AppRouter() {
    router = GoRouter(
      initialLocation: Routes.login,
      routes: [
        GoRoute(
          path: "/",
          builder: (context, state) => GardenPage()
        ),
        GoRoute(
          path: Routes.login,
          builder: (context, state) => LogInPage(),
        )
      ]
    );
  }

  late GoRouter router;
}