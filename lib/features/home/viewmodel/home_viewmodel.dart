import 'dart:io';
import 'dart:ui';

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/core/failure/failure.dart';
import 'package:spotify_clone/core/provider/current_user_notifier.dart';
import 'package:spotify_clone/core/utils.dart';
import 'package:spotify_clone/features/home/repository/home_repository.dart';

import '../model/songs_model.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongsModel>> getAllSongs(GetAllSongsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final res = await ref.watch(homeRepositoryProvider).fetchSongs(token: token);
  return switch (res) {
    Right<Failure, List<SongsModel>>(value: final r) => r,
    Left<Failure, List<SongsModel>>(value: final l) => throw l.message,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
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
}
