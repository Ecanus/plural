import 'package:go_router/go_router.dart';

// Constants
import 'package:plural_app/src/constants/routes.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/sign_in_page.dart';

// Garden
import 'package:plural_app/src/features/gardens/presentation/garden_page.dart';

class AppRouter {
  AppRouter() {
    router = GoRouter(
      initialLocation: Routes.signIn,
      routes: [
        GoRoute(
          path: "/",
          builder: (context, state) => GardenPage()
        ),
        GoRoute(
          path: Routes.signIn,
          builder: (context, state) => SignInPage(),
        )
      ]
    );
  }

  late GoRouter router;
}