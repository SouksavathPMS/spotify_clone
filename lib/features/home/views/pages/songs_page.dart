import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify_clone/features/home/viewmodel/home_viewmodel.dart';
import 'package:spotify_clone/features/home/views/pages/upload_song_page.dart';

class SongsPage extends ConsumerWidget {
  static const routeName = "songsPage";

  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: const Center(
        child: Text("SongsPage"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(homeViewModelProvider.notifier).getSongs();
          context.goNamed(UploadSongPage.routeName);
        },
      ),
    );
  }
}
