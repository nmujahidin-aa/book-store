import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/firebase/auth_service.dart';
import '../../../data/datasources/firebase/firestore_rent_service.dart';
import '../../../data/datasources/firebase/firestore_user_service.dart';
import '../../../data/datasources/remote/book_api_client.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../data/repositories/book_repository_impl.dart';
import '../../../data/repositories/rent_repository_impl.dart';
import '../../../data/repositories/user_repository_impl.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/book_repository.dart';
import '../../../domain/repositories/rent_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../domain/usecases/auth/forgot_password.dart';
import '../../../domain/usecases/auth/login.dart';
import '../../../domain/usecases/auth/logout.dart';
import '../../../domain/usecases/auth/register.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref.watch(firebaseAuthProvider)));
final firestoreUserServiceProvider =
    Provider<FirestoreUserService>((ref) => FirestoreUserService(ref.watch(firestoreProvider)));
final firestoreRentServiceProvider =
    Provider<FirestoreRentService>((ref) => FirestoreRentService(ref.watch(firestoreProvider)));
final bookApiClientProvider = Provider<BookApiClient>((ref) => BookApiClient(ref.watch(dioProvider)));

final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepositoryImpl(ref.watch(firestoreUserServiceProvider)));
final rentRepositoryProvider = Provider<RentRepository>((ref) => RentRepositoryImpl(ref.watch(firestoreRentServiceProvider)));
final bookRepositoryProvider = Provider<BookRepository>((ref) => BookRepositoryImpl(ref.watch(bookApiClientProvider)));

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authServiceProvider), ref.watch(userRepositoryProvider));
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final user = ref.watch(authStateChangesProvider).asData?.value;
  if (user == null) return Stream.value(null);
  return ref.watch(userRepositoryProvider).watchProfile(user.uid);
});

class AuthUiState {
  final bool isLoading;
  const AuthUiState({required this.isLoading});
  factory AuthUiState.initial() => const AuthUiState(isLoading: false);

  AuthUiState copyWith({bool? isLoading}) => AuthUiState(isLoading: isLoading ?? this.isLoading);
}

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthUiState>(AuthViewModel.new);

class AuthViewModel extends Notifier<AuthUiState> {
  late final LoginUsecase _login = LoginUsecase(ref.read(authRepositoryProvider));
  late final RegisterUsecase _register = RegisterUsecase(ref.read(authRepositoryProvider));
  late final ForgotPasswordUsecase _forgot = ForgotPasswordUsecase(ref.read(authRepositoryProvider));
  late final LogoutUsecase _logout = LogoutUsecase(ref.read(authRepositoryProvider));

  @override
  AuthUiState build() => AuthUiState.initial();

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true);
    try {
      await _login(email: email, password: password);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> register({required String name, required String email, required String password}) async {
    state = state.copyWith(isLoading: true);
    try {
      await _register(name: name, email: email, password: password);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> forgotPassword({required String email}) async {
    state = state.copyWith(isLoading: true);
    try {
      await _forgot(email: email);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logout() async {
    await _logout();
  }
}