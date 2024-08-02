import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as https;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/core/failure/failure.dart';

import '../../../core/config/path_config.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) => HomeRepository();

class HomeRepository {
  Future<Either<Failure, String>> uploadSong({
    required File seletedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = https.MultipartRequest(
        "POST",
        Uri.parse(
          "${PathConfig.serverUrl}${PathConfig.uploadSong}",
        ),
      );
      request
        ..files.addAll([
          await https.MultipartFile.fromPath("song", seletedAudio.path),
          await https.MultipartFile.fromPath(
              "thumbnail", selectedThumbnail.path),
        ])
        ..fields.addAll({
          "artist": artist,
          "song_name": songName,
          "hex_code": hexCode,
        })
        ..headers.addAll({
          "x-auth-token": token,
        });

      final res = await request.send();

      if (res.statusCode != 200) {
        return left(Failure(await res.stream.bytesToString()));
      }
      return right(await res.stream.bytesToString());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
