import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/features/auth/views/pages/signin_page.dart';
import 'package:spotify_clone/features/auth/views/pages/signup_page.dart';

import '../../features/auth/viewmodel/auth_viewmodel.dart';
import '../../features/home/views/pages/home_screen.dart';

part "app_router_provider.g.dart";

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      // __________________________________________
      // We can also do this but it won't work when there is no internet connection
      // final authViewModel = ref.read(currentUserNotifierProvider);
      // final loggedIn = authViewModel != null;
      // __________________________________________
      final authViewModel = ref.read(authViewModelProvider.notifier);
      final loggedIn = await authViewModel.isLoggedIn();
      final loginloc = state.namedLocation(SigninPage.routeName);
      final loggingIn = state.matchedLocation == loginloc;

      final signupLoc = state.namedLocation(SignupPage.routeName);
      final signingUp = state.matchedLocation == signupLoc;

      // bundle the location the user is coming from into a query parameter
      final mainloc = state.namedLocation(HomeScreen.routeName);
      final fromloc =
          state.matchedLocation == mainloc ? '' : state.matchedLocation;
      if (!loggedIn) {
        return loggingIn || signingUp
            ? null
            : state.namedLocation(
                SigninPage.routeName,
                queryParameters: {if (fromloc.isNotEmpty) 'from': fromloc},
              );
      }

      if (loggingIn) return state.uri.queryParameters['from'] ?? mainloc;
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: "/",
        name: HomeScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: "/${SigninPage.routeName}",
        name: SigninPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const SigninPage();
        },
      ),
      GoRoute(
        path: "/${SignupPage.routeName}",
        name: SignupPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const SignupPage();
        },
      ),
    ],
  );
  return router;
}
