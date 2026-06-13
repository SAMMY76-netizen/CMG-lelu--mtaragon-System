import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/firestore_constants.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final UserRole role;
  final UserStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLogin;
  final DateTime? deletedAt;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.phoneNumber,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.lastLogin,
    this.deletedAt,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isTreasurer => role == UserRole.treasurer;
  bool get isSecretary => role == UserRole.secretary;
  bool get isMember => role == UserRole.member;
  bool get isActive => status == UserStatus.active;

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    UserRole? role,
    UserStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
    DateTime? deletedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.uid: uid,
      FirestoreConstants.email: email,
      FirestoreConstants.displayName: displayName,
      FirestoreConstants.photoUrl: photoUrl,
      FirestoreConstants.phoneNumber: phoneNumber,
      FirestoreConstants.role: role.name,
      FirestoreConstants.status: status.name,
      FirestoreConstants.createdAt: Timestamp.fromDate(createdAt),
      FirestoreConstants.updatedAt: Timestamp.fromDate(updatedAt),
      FirestoreConstants.lastLogin: lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      FirestoreConstants.deletedAt: deletedAt != null ? Timestamp.fromDate(deletedAt!) : null,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map[FirestoreConstants.uid] ?? '',
      email: map[FirestoreConstants.email] ?? '',
      displayName: map[FirestoreConstants.displayName] ?? '',
      photoUrl: map[FirestoreConstants.photoUrl],
      phoneNumber: map[FirestoreConstants.phoneNumber],
      role: UserRole.fromString(map[FirestoreConstants.role] ?? 'member'),
      status: UserStatus.fromString(map[FirestoreConstants.status] ?? 'active'),
      createdAt: (map[FirestoreConstants.createdAt] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map[FirestoreConstants.updatedAt] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLogin: (map[FirestoreConstants.lastLogin] as Timestamp?)?.toDate(),
      deletedAt: (map[FirestoreConstants.deletedAt] as Timestamp?)?.toDate(),
    );
  }

  @override
  String toString() => 'UserModel(uid: $uid, email: $email, displayName: $displayName, role: $role)';
}
