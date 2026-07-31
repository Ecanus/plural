import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_future_builder_error.dart';
import 'package:plural_app/src/common_widgets/app_future_builder_loading.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/presentation/sponsored_ask_tile.dart';
import 'package:plural_app/src/features/asks/presentation/sponsored_asks_view.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/users_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/route_to_view_button.dart';

// Tests
import '../../../test_factories.dart';
import '../../../test_mocks.dart';
import '../../../test_record_models.dart';
import '../../../test_stubs/asks_api_stubs.dart';

void main() {
  group("SponsoredAsksView", () {
    testWidgets("snapshot.hasData", (tester) async {
      final user = AppUserFactory();
      final garden = GardenFactory(); // for getAsksByUserID
      final userGardenRecord = AppUserGardenRecordFactory(user: user, garden: garden);

      final appState = AppState.skipSubscribe()
        ..currentUserGardenRecord = userGardenRecord
        ..currentUser = user;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      getAsksByGardenIDStub(
        mockAsksRepository: mockAsksRepository,
        asksReturnValue: ResultList<RecordModel>(items: [
          getAskRecordModel(ask: AskFactory(creator: user)),
          getAskRecordModel(ask: AskFactory(creator: user)),
          getAskRecordModel(ask: AskFactory(creator: user))
        ]),
        mockUsersRepository: mockUsersRepository,
        userID: user.id,
        usersReturnValue: getUserRecordModel(user: user),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialog(
              view: SponsoredAsksView()
            )
          ),
        )
      );

      // Check that GardenTimelineLoading is rendered first
      expect(find.byType(AppFutureBuilderLoading), findsOneWidget);

      // Finish animations
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(SponsoredAsksView), findsOneWidget);
      expect(find.byType(SponsoredAskTile), findsNWidgets(3));
      expect(find.byType(AppDialogFooterBuffer), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);

      expect(find.byType(RouteToViewButton), findsNWidgets(2));
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("snapshot.hasData empty", (tester) async {
      final user = AppUserFactory();
      final garden = GardenFactory(); // for getAsksByUserID
      final userGardenRecord = AppUserGardenRecordFactory(user: user, garden: garden);

      final appState = AppState.skipSubscribe()
        ..currentUserGardenRecord = userGardenRecord
        ..currentUser = user;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      getAsksByGardenIDStub(
        mockAsksRepository: mockAsksRepository,
        asksReturnValue: ResultList<RecordModel>(items: []),
        mockUsersRepository: mockUsersRepository,
        userID: user.id,
        usersReturnValue: getUserRecordModel(user: user),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialog(
              view: SponsoredAsksView()
            )
          ),
        )
      );

      // Check that GardenTimelineLoading is rendered first
      expect(find.byType(AppFutureBuilderLoading), findsOneWidget);

      // Finish animations
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(SponsoredAsksView), findsOneWidget);
      expect(find.byType(EmptySponsoredAsksViewMessage), findsOneWidget);
      expect(find.byType(SponsoredAskTile), findsNothing);
      expect(find.byType(AppDialogFooterBuffer), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);

      expect(find.byType(RouteToViewButton), findsNWidgets(2));
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets("snapshot.hasError", (tester) async {
      final user = AppUserFactory();
      final garden = GardenFactory(); // for getAsksByUserID
      final userGardenRecord = AppUserGardenRecordFactory(user: user, garden: garden);

      final appState = AppState.skipSubscribe()
        ..currentUserGardenRecord = userGardenRecord
        ..currentUser = user;

      final getIt = GetIt.instance;
      final mockAsksRepository = MockAsksRepository();
      final mockUsersRepository = MockUsersRepository();
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AsksRepository>(() => mockAsksRepository);
      getIt.registerLazySingleton<UsersRepository>(() => mockUsersRepository);

      // Stubs
      // mockAsksRepository.getList()
      when(
        () => mockAsksRepository.getList(
          filter: any(named: "filter"),
          sort: any(named: "sort"),
        )
      ).thenThrow(
        Exception("an error is thrown!")
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialog(
              view: SponsoredAsksView()
            )
          ),
        )
      );

      // Check that GardenTimelineLoading is rendered first
      expect(find.byType(AppFutureBuilderLoading), findsOneWidget);

      // Finish animations
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(SponsoredAsksView), findsOneWidget);
      expect(find.byType(AppFutureBuilderError), findsOneWidget);
      expect(find.byType(SponsoredAskTile), findsNothing);
      expect(find.byType(AppDialogFooterBuffer), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);

      expect(find.byType(RouteToViewButton), findsNWidgets(2));
    });

    tearDown(() => GetIt.instance.reset());
  });
}