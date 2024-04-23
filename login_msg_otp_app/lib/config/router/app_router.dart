import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/vetpet/presentation/screens.dart';
import 'app_router_notifier.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      GoRoute(
        path: '/phone-not-verified',
        builder: (context, state) => const PhoneNotVerifiedScreen(),
      ),

      GoRoute(
        path: '/phone-authenticator',
        builder: (context, state) => const PhoneAuthenticatorScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const AdminVetPetScreen(),
      ),
    ],
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      // print('GoRouter authStatus: $authStatus, isGoingTo: $isGoingTo');

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking)
        return null;

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;

        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          return '/';
        }
      }

      if (authStatus == AuthStatus.phoneNotAuthenticated) {
        if (isGoingTo == '/phone-authenticator') return null;
        if( isGoingTo != 'phone-not-verified' || isGoingTo != '/phone-authenticator'){
          return '/phone-not-verified'; 
        }
      }

      return '/';
    },
  );
});
