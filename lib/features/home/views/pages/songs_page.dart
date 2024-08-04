import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SongsPage extends ConsumerWidget {
  static const routeName = "songsPage";

  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Text("SongsPage"),
    );
  }
}
