import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LibraryPage extends ConsumerWidget {
  static const routeName = "libraryPage";

  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Text("LibraryPage"),
    );
  }
}
