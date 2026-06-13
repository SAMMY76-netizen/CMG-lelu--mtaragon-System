import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../../features/authentication/presentation/screens/signup_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/members/presentation/screens/members_screen.dart';
import '../../features/members/presentation/screens/member_detail_screen.dart';
import '../../../services/auth_service.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);
  
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      final isLoggedIn = authService.isLoggedIn;
      
      if (!isLoggedIn && state.location != '/login' && state.location != '/forgot-password' && state.location != '/signup') {
        return '/login';
      }
      
      if (isLoggedIn && (state.location == '/login' || state.location == '/forgot-password' || state.location == '/signup')) {
        return '/dashboard';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/members',
        builder: (context, state) => const MembersScreen(),
        routes: [
          GoRoute(
            path: ':memberId',
            builder: (context, state) {
              final memberId = state.pathParameters['memberId']!;
              return MemberDetailScreen(memberId: memberId);
            },
          ),
        ],
      ),
    ],
  );
});
