import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as https;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/core/failure/failure.dart';
import 'package:spotify_clone/features/home/model/songs_model.dart';

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

  Future<Either<Failure, List<SongsModel>>> fetchSongs({
    required String token,
  }) async {
    try {
      final res = await https.get(
        Uri.parse(
          "${PathConfig.serverUrl}${PathConfig.songsList}",
        ),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": token,
        },
      );

      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return left(Failure(resBodyMap["detail"]));
      }
      resBodyMap = resBodyMap as List;
      final songsList = resBodyMap
          .map(
            (e) => SongsModel.fromJson(e),
          )
          .toList();

      return right(songsList);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> favSong({
    required String token,
    required String songId,
  }) async {
    try {
      final res = await https.post(
        Uri.parse("${PathConfig.serverUrl}${PathConfig.favorite}"),
        body: jsonEncode(
          {
            "song_id": songId,
          },
        ),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": token,
        },
      );
      var responseBody = jsonDecode(res.body);
      if (res.statusCode != 200) {
        responseBody = responseBody as Map<String, dynamic>;
        return left(Failure(responseBody["detail"]));
      }
      return right(responseBody["message"]);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<SongsModel>>> fetchFavSongs({
    required String token,
  }) async {
    try {
      final res = await https.get(
        Uri.parse(
          "${PathConfig.serverUrl}${PathConfig.favoriteSongs}",
        ),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": token,
        },
      );

      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return left(Failure(resBodyMap["detail"]));
      }
      resBodyMap = resBodyMap as List;
      final favSongList = resBodyMap
          .map(
            (e) => SongsModel.fromJson(e["song"]),
          )
          .toList();

      return right(favSongList);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
