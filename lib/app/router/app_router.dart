import 'package:disney/features/landing/presentation/screens/landing_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingScreen(),
      ),
    ],
  );
}
