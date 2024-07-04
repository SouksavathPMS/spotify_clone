import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/core/config/path_config.dart';
import 'package:spotify_clone/core/failure/failure.dart';

import '../model/user_model.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository();
}

class AuthRepository {
  Future<Either<Failure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${PathConfig.serverUrl}${PathConfig.signup}"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 201) {
        return Left(Failure(resBodyMap["detail"]));
      }
      return Right(UserModel.fromMap(resBodyMap["user"]));
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> signin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          "${PathConfig.serverUrl}${PathConfig.signin}",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(Failure(resBodyMap["detail"]));
      }

      return Right(
        UserModel.fromMap(resBodyMap["user"])
            .copyWith(token: resBodyMap["token"]),
      );
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
