// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String token;
  final User user;

  UserModel({
    required this.token,
    required this.user,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        token: json["token"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
      };

  UserModel copyWith({
    String? token,
    User? user,
  }) {
    return UserModel(
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }
}

class User {
  final String email;
  final String name;
  final String id;
  final List<Favorite> favorites;

  User({
    required this.email,
    required this.name,
    required this.id,
    required this.favorites,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        name: json["name"],
        id: json["id"],
        favorites: List<Favorite>.from(
            json["favorites"].map((x) => Favorite.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "id": id,
        "favorites": List<dynamic>.from(favorites.map((x) => x.toJson())),
      };

  User copyWith({
    String? email,
    String? name,
    String? id,
    List<Favorite>? favorites,
  }) {
    return User(
      email: email ?? this.email,
      name: name ?? this.name,
      id: id ?? this.id,
      favorites: favorites ?? this.favorites,
    );
  }
}

class Favorite {
  final String songId;
  final String id;
  final String userId;

  Favorite({
    required this.songId,
    required this.id,
    required this.userId,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        songId: json["song_id"],
        id: json["id"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "song_id": songId,
        "id": id,
        "user_id": userId,
      };
}
