// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final songsModel = songsModelFromJson(jsonString);

import 'dart:convert';

SongsModel songsModelFromJson(String str) =>
    SongsModel.fromJson(json.decode(str));

String songsModelToJson(SongsModel data) => json.encode(data.toJson());

class SongsModel {
  final String songUrl;
  final String thumbnail;
  final String songName;
  final String id;
  final String artist;
  final String hexCode;

  SongsModel({
    required this.songUrl,
    required this.thumbnail,
    required this.songName,
    required this.id,
    required this.artist,
    required this.hexCode,
  });

  factory SongsModel.fromJson(Map<String, dynamic> json) => SongsModel(
        songUrl: json["song_url"],
        thumbnail: json["thumbnail"],
        songName: json["song_name"],
        id: json["id"],
        artist: json["artist"],
        hexCode: json["hex_code"],
      );

  Map<String, dynamic> toJson() => {
        "song_url": songUrl,
        "thumbnail": thumbnail,
        "song_name": songName,
        "id": id,
        "artist": artist,
        "hex_code": hexCode,
      };

  SongsModel copyWith({
    String? songUrl,
    String? thumbnail,
    String? songName,
    String? id,
    String? artist,
    String? hexCode,
  }) {
    return SongsModel(
      songUrl: songUrl ?? this.songUrl,
      thumbnail: thumbnail ?? this.thumbnail,
      songName: songName ?? this.songName,
      id: id ?? this.id,
      artist: artist ?? this.artist,
      hexCode: hexCode ?? this.hexCode,
    );
  }
}
