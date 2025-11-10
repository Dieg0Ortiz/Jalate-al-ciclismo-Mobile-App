import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../features/planner/presentation/screens/planner_screen.dart';
import '../../features/navigation/presentation/screens/navigation_screen.dart';
import '../../features/activity/presentation/screens/activity_screen.dart';
import '../../features/activity/presentation/screens/activity_detail_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/my_bikes_screen.dart';
import '../../features/profile/presentation/screens/my_sensors_screen.dart';
import '../../features/profile/presentation/screens/offline_maps_screen.dart';
import '../../features/profile/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/navigation_settings_screen.dart';
import '../../features/profile/presentation/screens/help_support_screen.dart';
import '../../features/profile/presentation/screens/connections_screen.dart';
import '../../features/profile/presentation/screens/terms_screen.dart';
import '../../features/profile/presentation/screens/privacy_screen.dart';

class AppRouter {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const Scaffold(
          body: HomeScreen(),
          bottomNavigationBar: BottomNavBar(),
        ),
      ),
      GoRoute(
        path: '/planner',
        builder: (context, state) => const Scaffold(
          body: PlannerScreen(),
          bottomNavigationBar: BottomNavBar(),
        ),
      ),
      GoRoute(
        path: '/navigation',
        builder: (context, state) => const Scaffold(
          body: NavigationScreen(),
          bottomNavigationBar: BottomNavBar(),
        ),
      ),
      GoRoute(
        path: '/activity',
        builder: (context, state) => const Scaffold(
          body: ActivityScreen(),
          bottomNavigationBar: BottomNavBar(),
        ),
      ),
      GoRoute(
        path: '/activity/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ActivityDetailScreen(activityId: id);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const Scaffold(
          body: ProfileScreen(),
          bottomNavigationBar: BottomNavBar(),
        ),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/bikes',
        builder: (context, state) => const MyBikesScreen(),
      ),
      GoRoute(
        path: '/profile/sensors',
        builder: (context, state) => const MySensorsScreen(),
      ),
      GoRoute(
        path: '/profile/maps',
        builder: (context, state) => const OfflineMapsScreen(),
      ),
      GoRoute(
        path: '/profile/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/profile/navigation-settings',
        builder: (context, state) => const NavigationSettingsScreen(),
      ),
      GoRoute(
        path: '/profile/help',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: '/profile/connections/:type',
        builder: (context, state) {
          final type = state.pathParameters['type']!;
          return ConnectionsScreen(connectionType: type);
        },
      ),
      GoRoute(
        path: '/profile/terms',
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: '/profile/privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
    ],
    redirect: (context, state) {
      try {
        final authBloc = context.read<AuthBloc>();
        final currentState = authBloc.state;
        final isLoggedIn = currentState is AuthAuthenticated;
        final isAuthRoute = state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        // Si no está logueado y no está en una ruta de auth, redirigir a login
        if (!isLoggedIn && !isAuthRoute) {
          return '/login';
        }

        // Si está logueado y está en una ruta de auth, redirigir a home
        // Pero solo si no está en proceso de login (evitar loop)
        if (isLoggedIn && isAuthRoute && currentState is! AuthLoading) {
          return '/home';
        }
      } catch (e) {
        // AuthBloc not available yet, allow navigation
      }
      return null;
    },
  );
}
