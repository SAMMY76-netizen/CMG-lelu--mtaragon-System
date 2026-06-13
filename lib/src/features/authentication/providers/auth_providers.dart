import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/local_storage_service.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../../../core/utils/result.dart';

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Current user provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  
  if (!authService.isLoggedIn) {
    return null;
  }

  final result = await authService.getCurrentUser();
  return result.fold(
    (failure) => null,
    (user) => user,
  );
});

// Login provider
final loginProvider = FutureProvider.family<Result<UserModel>, (String, String)>(
  (ref, params) async {
    final authService = ref.watch(authServiceProvider);
    return authService.signIn(
      email: params.$1,
      password: params.$2,
    );
  },
);

// Sign up provider
final signUpProvider = FutureProvider.family<Result<UserModel>, (String, String, String)>(
  (ref, params) async {
    final authService = ref.watch(authServiceProvider);
    return authService.signUp(
      email: params.$1,
      password: params.$2,
      displayName: params.$3,
    );
  },
);

// Sign out provider
final signOutProvider = FutureProvider<Result<void>>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final result = await authService.signOut();
  
  if (result.isRight()) {
    await LocalStorageService.clearAll();
  }
  
  return result;
});

// Password reset provider
final resetPasswordProvider = FutureProvider.family<Result<void>, String>(
  (ref, email) async {
    final authService = ref.watch(authServiceProvider);
    return authService.resetPassword(email: email);
  },
);

import 'package:firebase_auth/firebase_auth.dart';
