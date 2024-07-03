import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify_clone/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:spotify_clone/features/auth/views/pages/signin_page.dart';

class HomeScreen extends ConsumerWidget {
  static const routeName = "home";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            context.goNamed(SigninPage.routeName);
            ref.read(authViewModelProvider.notifier).signOut();
          },
          child: const Text("Log out"),
        ),
      ),
    );
  }
}
