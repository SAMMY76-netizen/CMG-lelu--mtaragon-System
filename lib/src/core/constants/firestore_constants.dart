class FirestoreConstants {
  // Collections
  static const String usersCollection = 'users';
  static const String membersCollection = 'members';
  static const String rolesCollection = 'roles';
  static const String permissionsCollection = 'permissions';
  static const String logsCollection = 'logs';
  static const String transactionsCollection = 'transactions';
  static const String eventsCollection = 'events';
  
  // Document fields
  static const String uid = 'uid';
  static const String email = 'email';
  static const String displayName = 'displayName';
  static const String photoUrl = 'photoUrl';
  static const String phoneNumber = 'phoneNumber';
  static const String role = 'role';
  static const String status = 'status';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String lastLogin = 'lastLogin';
  static const String deletedAt = 'deletedAt';
  static const String address = 'address';
  static const String city = 'city';
  static const String state = 'state';
  static const String zipCode = 'zipCode';
  static const String membershipDate = 'membershipDate';
  static const String emergencyContact = 'emergencyContact';
  static const String emergencyPhone = 'emergencyPhone';
}

enum UserRole {
  admin('Admin'),
  treasurer('Treasurer'),
  secretary('Secretary'),
  member('Member');
  
  final String displayName;
  const UserRole(this.displayName);
  
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => UserRole.member,
    );
  }
}

enum UserStatus {
  active('Active'),
  inactive('Inactive'),
  suspended('Suspended'),
  deleted('Deleted');
  
  final String displayName;
  const UserStatus(this.displayName);
  
  static UserStatus fromString(String value) {
    return UserStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => UserStatus.active,
    );
  }
}
