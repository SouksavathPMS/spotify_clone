import 'dart:io';
import 'dart:ui';

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/core/failure/failure.dart';
import 'package:spotify_clone/core/provider/current_user_notifier.dart';
import 'package:spotify_clone/core/utils.dart';
import 'package:spotify_clone/features/auth/model/user_model.dart';
import 'package:spotify_clone/features/home/repository/home_local_repository.dart';
import 'package:spotify_clone/features/home/repository/home_repository.dart';

import '../model/songs_model.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongsModel>> getAllSongs(GetAllSongsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((value) => value!.token));
  final res = await ref.watch(homeRepositoryProvider).fetchSongs(token: token);
  return switch (res) {
    Right<Failure, List<SongsModel>>(value: final r) => r,
    Left<Failure, List<SongsModel>>(value: final l) => throw l.message,
  };
}

@riverpod
Future<List<SongsModel>> getFavSongs(GetFavSongsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((value) => value!.token));
  final res =
      await ref.watch(homeRepositoryProvider).fetchFavSongs(token: token);
  return switch (res) {
    Right<Failure, List<SongsModel>>(value: final r) => r,
    Left<Failure, List<SongsModel>>(value: final l) => throw l.message,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;
  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  // Future<void> getSongs() async {

  //   print(songs);
  // }

  Future<void> uploadSong({
    required File seletedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color seletedColor,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.uploadSong(
      seletedAudio: seletedAudio,
      selectedThumbnail: selectedThumbnail,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(seletedColor),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final _ = switch (res) {
      Left<Failure, String>(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right<Failure, String>(value: final r) => state = AsyncValue.data(r),
    };
  }

  List<SongsModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.loadSongs();
  }

  Future<void> favSong(String songId) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.favSong(
      songId: songId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final _ = switch (res) {
      Left<Failure, bool>(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right<Failure, bool>(value: final r) => _favSongSuccess(r, songId),
    };
  }

  AsyncValue _favSongSuccess(bool isFavorited, String songId) {
    final currentUser = ref.read(currentUserNotifierProvider);
    if (isFavorited) {
      ref.read(currentUserNotifierProvider.notifier).updateUser(
            currentUser?.copyWith(
              user: currentUser.user.copyWith(
                favorites: [
                  ...currentUser.user.favorites,
                  Favorite(songId: songId, id: "", userId: ""),
                ],
              ),
            ),
          );
    } else {
      ref.read(currentUserNotifierProvider.notifier).updateUser(
            currentUser?.copyWith(
              user: currentUser.user.copyWith(
                favorites: currentUser.user.favorites
                    .where(
                      (element) => element.songId != songId,
                    )
                    .toList(),
              ),
            ),
          );
    }
    return state = AsyncValue.data(isFavorited);
  }
}
