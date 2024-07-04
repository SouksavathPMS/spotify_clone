import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/features/auth/model/user_model.dart';
import 'package:spotify_clone/features/auth/repository/auth_local_repository.dart';
import 'package:spotify_clone/features/auth/repository/auth_repository.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRepository _authRepository;
  late AuthLocalRepository _authLocalRepository;
  @override
  AsyncValue<UserModel>? build() {
    _authRepository = ref.watch(authRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    return null;
  }

  Future<bool> isLoggedIn() async {
    // await _authLocalRepository.init();
    final userSession = _authLocalRepository.getToken();
    return userSession != null;
  }

  Future<void> signOut() async {
    // await _authLocalRepository.init();
    _authLocalRepository.removeToken();
    state = null;
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final signupRes = await _authRepository.signup(
      name: name,
      email: email,
      password: password,
    );

    return signupRes.fold(
      (l) {
        state = AsyncValue.error(l.message, StackTrace.current);
        return false;
      },
      (r) => true,
    );
    // final _ = switch (signupRes) {
    //   Left<Failure, UserModel>(value: final l) => ,
    //   Right<Failure, UserModel>(value: final r) =>,
    // };
  }

  Future<bool> signin({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final signinRes = await _authRepository.signin(
      email: email,
      password: password,
    );

    return signinRes.fold(
      (l) {
        state = AsyncValue.error(l.message, StackTrace.current);
        return false;
      },
      (r) {
        _authLocalRepository.setToken(r.token);
        state = AsyncValue.data(r);
        return true;
      },
    );
    // final val = switch (signinRes) {
    //   Left<Failure, UserModel>(value: final l) => state =
    //       AsyncValue.error(l.message, StackTrace.current),
    //   Right<Failure, UserModel>(value: final r) => state = AsyncValue.data(r),
    // };
    // val.whenData(
    //   (value) {
    //     _authRepository.saveUserSession(value.id);
    //   },
    // );
  }
}
