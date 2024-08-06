import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify_clone/core/provider/current_song_notifier.dart';
import 'package:spotify_clone/core/theme/app_pallete.dart';
import 'package:spotify_clone/features/home/viewmodel/home_viewmodel.dart';
import 'package:spotify_clone/features/home/views/pages/upload_song_page.dart';

class LibraryPage extends ConsumerWidget {
  static const routeName = "libraryPage";

  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getFavSongsProvider).when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (context, index) {
                if (index == data.length) {
                  return ListTile(
                    leading: const Icon(CupertinoIcons.add),
                    title: const Text(
                      "Upload new song",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const UploadSongPage(),
                      ),
                    ),
                  );
                }
                final song = data.elementAt(index);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(song.thumbnail),
                  ),
                  title: Text(
                    song.songName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    song.songName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Pallete.subtitleText,
                    ),
                  ),
                  onTap: () => ref
                      .read(currentSongNotifierProvider.notifier)
                      .upDateSong(song),
                );
              },
            );
          },
          error: (error, stackTrace) => Center(
            child: Text(
              stackTrace.toString(),
            ),
          ),
          loading: () => const SizedBox(),
        );
  }
}
