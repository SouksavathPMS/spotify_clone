import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/features/auth/views/pages/signin_page.dart';
import 'package:spotify_clone/features/auth/views/pages/signup_page.dart';

import '../../features/home/views/pages/home_screen.dart';

part "app_router_provider.g.dart";

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: "/${HomeScreen.routeName}",
    redirect: (context, state) {
      // TODO Check if the user has already loggedin or not
      const loggedIn = false;
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

      // ignore: dead_code
      if (loggingIn) return state.uri.queryParameters['from'] ?? mainloc;
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: "/${HomeScreen.routeName}",
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