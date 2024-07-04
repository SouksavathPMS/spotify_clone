import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_repository.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(AuthLocalRepositoryRef ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void setToken(String? token) async {
    if (token != null) {
      _sharedPreferences.setString("x-auth-token", token);
    }
  }

  String? getToken() => _sharedPreferences.getString("x-auth-token");

  void removeToken() {
    _sharedPreferences.remove("x-auth-token");
  }
}
