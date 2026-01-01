import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/auth/forgot_password_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/book/book_detail_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/rent/order_rent_page.dart';
import '../../presentation/pages/rent/rent_list_page.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/viewmodels/auth/auth_viewmodel.dart';
import 'go_router_refresh_stream.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authStateChangesProvider);

  final authRepo = ref.read(authRepositoryProvider);
  final refresh = GoRouterRefreshStream(authRepo.authStateChanges());
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final loc = state.matchedLocation;

      if (authAsync.isLoading) {
        return loc == '/splash' ? null : '/splash';
      }

      final User? user = authAsync.maybeWhen(
        data: (u) => u,
        orElse: () => null,
      );

      if (loc == '/splash') {
        return user == null ? '/login' : '/home';
      }

      final isAuthRoute = loc == '/login' || loc == '/register' || loc == '/forgot';

      if (user == null) {
        return isAuthRoute ? null : '/login';
      }

      if (isAuthRoute) return '/home';

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(path: '/forgot', builder: (_, __) => const ForgotPasswordPage()),
      GoRoute(path: '/home', builder: (_, __) => const HomePage()),
      GoRoute(
        path: '/book',
        builder: (_, state) => BookDetailPage(book: state.extra as dynamic),
      ),
      GoRoute(
        path: '/rent/order',
        builder: (_, state) => OrderRentPage(book: state.extra as dynamic),
      ),
      GoRoute(path: '/rent/list', builder: (_, __) => const RentListPage()),
    ],
  );
});