import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/result.dart';
import '../../../core/constants/firestore_constants.dart';
import '../../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool get isLoggedIn => _firebaseAuth.currentUser != null;
  User? get currentUser => _firebaseAuth.currentUser;
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<Result<UserModel>> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(displayName);

      final userModel = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        displayName: displayName,
        role: UserRole.member,
        status: UserStatus.active,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());

      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      return Left(
        Failure(
          message: _getErrorMessage(e.code),
          code: e.code,
        ),
      );
    } catch (e) {
      return Left(
        Failure(
          message: 'An error occurred during registration',
          exception: e as Exception,
        ),
      );
    }
  }

  Future<Result<UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      final userModel = UserModel.fromMap(userDoc.data()!);

      // Update last login
      await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(userCredential.user!.uid)
          .update({
        FirestoreConstants.lastLogin: DateTime.now(),
      });

      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      return Left(
        Failure(
          message: _getErrorMessage(e.code),
          code: e.code,
        ),
      );
    } catch (e) {
      return Left(
        Failure(
          message: 'An error occurred during login',
          exception: e as Exception,
        ),
      );
    }
  }

  Future<Result<void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(
        Failure(
          message: 'An error occurred during sign out',
          exception: e as Exception,
        ),
      );
    }
  }

  Future<Result<void>> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(
        Failure(
          message: _getErrorMessage(e.code),
          code: e.code,
        ),
      );
    } catch (e) {
      return Left(
        Failure(
          message: 'An error occurred while sending reset email',
          exception: e as Exception,
        ),
      );
    }
  }

  Future<Result<UserModel>> getCurrentUser() async {
    try {
      if (currentUserId == null) {
        return Left(
          Failure(message: 'No user logged in'),
        );
      }

      final userDoc = await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(currentUserId)
          .get();

      if (!userDoc.exists) {
        return Left(
          Failure(message: 'User data not found'),
        );
      }

      return Right(UserModel.fromMap(userDoc.data()!));
    } catch (e) {
      return Left(
        Failure(
          message: 'An error occurred while fetching user',
          exception: e as Exception,
        ),
      );
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'User not found';
      case 'wrong-password':
        return 'Wrong password';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      case 'user-disabled':
        return 'User account is disabled';
      default:
        return 'Authentication error: $code';
    }
  }
}
