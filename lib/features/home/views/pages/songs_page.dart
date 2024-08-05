import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify_clone/core/provider/current_song_notifier.dart';
import 'package:spotify_clone/core/theme/app_pallete.dart';
import 'package:spotify_clone/core/utils.dart';
import 'package:spotify_clone/features/home/viewmodel/home_viewmodel.dart';

class SongsPage extends ConsumerWidget {
  static const routeName = "songsPage";

  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSongs =
        ref.watch(homeViewModelProvider.notifier).getRecentlyPlayedSongs();
    final currentSong = ref.watch(currentSongNotifierProvider);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: currentSong == null
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  hexToColor(currentSong.hexCode),
                  Pallete.backgroundColor,
                ],
                stops: const [0.0, 0.2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, bottom: 28),
            child: SizedBox(
              height: 280,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final song = recentlyPlayedSongs.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(currentSongNotifierProvider.notifier)
                          .upDateSong(song);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Pallete.cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  song.thumbnail,
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              song.songName,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: recentlyPlayedSongs.length,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Recommended today",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ref.watch(getAllSongsProvider).when(
                data: (songs) {
                  return SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final song = songs.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: GestureDetector(
                            onTap: () => ref
                                .read(currentSongNotifierProvider.notifier)
                                .upDateSong(song),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        song.thumbnail,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    song.songName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    song.songName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Pallete.subtitleText,
                                    ),
                                    maxLines: 1,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: songs.length,
                    ),
                  );
                },
                error: (error, stackTrace) => Center(
                  child: Text(
                    error.toString(),
                  ),
                ),
                loading: () => const SizedBox(),
              ),
        ],
      ),
    );
  }
}
