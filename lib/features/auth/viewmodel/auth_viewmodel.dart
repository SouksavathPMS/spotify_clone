import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/core/provider/current_user_notifier.dart';
import 'package:spotify_clone/features/auth/model/user_model.dart';
import 'package:spotify_clone/features/auth/repository/auth_local_repository.dart';
import 'package:spotify_clone/features/auth/repository/auth_repository.dart';

import '../../../core/failure/failure.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRepository _authRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;
  @override
  AsyncValue<UserModel>? build() {
    _authRepository = ref.watch(authRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
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

  Future<void> signUp({
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

    final _ = switch (signupRes) {
      Left<Failure, UserModel>(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right<Failure, UserModel>(value: final r) => state = AsyncValue.data(r),
    };
  }

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final signinRes = await _authRepository.signin(
      email: email,
      password: password,
    );
    final val = switch (signinRes) {
      Left<Failure, UserModel>(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right<Failure, UserModel>(value: final r) => state = AsyncValue.data(r),
    };
    val.whenData(
      (value) {
        _currentUserNotifier.updateUser(value);
        _authLocalRepository.setToken(value.token);
        state = AsyncValue.data(value);
      },
    );
  }

  Future<UserModel?> getUserData() async {
    final token = _authLocalRepository.getToken();
    if (token != null) {
      final res = await _authRepository.getUserData(token);
      final val = switch (res) {
        Left<Failure, UserModel>(value: final l) => state =
            AsyncValue.error(l.message, StackTrace.current),
        Right<Failure, UserModel>(value: final r) => state = AsyncValue.data(r),
      };
      val.whenData(
        (value) {
          _currentUserNotifier.updateUser(value);
        },
      );
      return val.value;
    }
    return null;
  }
}
