import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/core/failure/failure.dart';
import 'package:spotify_clone/features/auth/model/user_model.dart';
import 'package:spotify_clone/features/auth/repository/auth_repository.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRepository _authRepository;
  @override
  AsyncValue<UserModel>? build() {
    _authRepository = ref.watch(authRepositoryProvider);
    return null;
  }

  Future<bool> isLoggedIn() async {
    final userSession = await _authRepository.getUserSession();
    return userSession != null;
  }

  Future<void> signOut() async {
    await _authRepository.clearUserSession();
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
      Right<Failure, UserModel>(value: final r) => r,
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
        _authRepository.saveUserSession(value.id);
      },
    );
  }
}
