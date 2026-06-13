# CMG System - Flutter Android Application

A production-ready Community Management System built with Flutter, featuring Firebase integration, Riverpod state management, and comprehensive role-based access control.

## Features

### Authentication
- Email/Password authentication with Firebase Auth
- User registration with validation
- Password reset functionality
- Session management with local storage (Hive)
- Automatic login state persistence

### User Roles
- **Admin**: Full system access and management
- **Treasurer**: Financial management and reporting
- **Secretary**: Documentation and records management
- **Member**: Limited member profile access

### Dashboard
- Real-time statistics and analytics
- Member counts by role and status
- Quick action shortcuts
- Recent members overview

### Member Management
- View all members with real-time updates
- Search and filter by name, email, role, or status
- Detailed member profiles
- Member information management
- Emergency contact tracking

### Technical Stack

#### Core Framework
- **Flutter**: 3.16.0+
- **Dart**: 3.0.0+

#### State Management
- **Riverpod 2.4.0**: Type-safe reactive state management
- **Flutter Riverpod**: Flutter integration for Riverpod

#### Backend Services
- **Firebase Auth**: User authentication
- **Cloud Firestore**: Real-time database
- **Firebase Storage**: File and image storage

#### UI & Design
- **Material 3**: Latest Material Design specifications
- **Google Fonts**: Professional typography
- **Cached Network Image**: Optimized image loading

#### Local Storage
- **Hive**: Fast local key-value storage
- **Hive Flutter**: Flutter integration

#### Navigation
- **GoRouter**: Modern declarative routing

#### Architecture
- **Clean Architecture**: Separation of concerns
- **MVVM Pattern**: Model-View-ViewModel pattern
- **Repository Pattern**: Data layer abstraction

## Project Structure

```
lib/
├── main.dart
├── firebase_options.dart
├── src/
│   ├── config/
│   │   ├── router/
│   │   │   └── app_router.dart
│   │   └── theme/
│   │       ├── app_theme.dart
│   │       ├── app_colors.dart
│   │       └── app_text_styles.dart
│   ├── core/
│   │   ├── constants/
│   │   │   └── firestore_constants.dart
│   │   ├── extensions/
│   │   │   └── string_extensions.dart
│   │   ├── services/
│   │   │   └── local_storage_service.dart
│   │   └── utils/
│   │       └── result.dart
│   └── features/
│       ├── authentication/
│       │   ├── models/
│       │   │   └── user_model.dart
│       │   ├── services/
│       │   │   └── auth_service.dart
│       │   ├── providers/
│       │   │   └── auth_providers.dart
│       │   └── presentation/
│       │       ├── screens/
│       │       │   ├── login_screen.dart
│       │       │   ├── signup_screen.dart
│       │       │   └── forgot_password_screen.dart
│       │       └── widgets/
│       │           └── login_form.dart
│       ├── dashboard/
│       │   └── presentation/
│       │       └── screens/
│       │           └── dashboard_screen.dart
│       └── members/
│           ├── models/
│           │   └── member_model.dart
│           ├── repositories/
│           │   └── members_repository.dart
│           ├── providers/
│           │   └── members_providers.dart
│           └── presentation/
│               ├── screens/
│               │   ├── members_screen.dart
│               │   └── member_detail_screen.dart
│               └── widgets/
│                   ├── member_card.dart
│                   └── member_detail_widget.dart
```

## Getting Started

### Prerequisites
- Flutter 3.16.0 or higher
- Dart 3.0.0 or higher
- Android Studio or VS Code
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/SAMMY76-netizen/CMG-lelu--mtaragon-System.git
   cd CMG-lelu--mtaragon-System
   ```

2. **Switch to feature branch**
   ```bash
   git checkout feature/flutter-rebuild
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Configure Firebase**
   - Update `lib/firebase_options.dart` with your Firebase credentials
   - Ensure your Android and iOS apps are registered in Firebase Console

5. **Run the application**
   ```bash
   flutter run
   ```

### Firebase Setup

1. Create a Firebase project in the Firebase Console
2. Register Android and iOS apps
3. Download google-services.json (Android) and GoogleService-Info.plist (iOS)
4. Place configuration files in appropriate directories
5. Create Firestore collections:
   - `users`: Store user profiles
   - `members`: Store member information
   - `roles`: Role definitions
   - `permissions`: Permission mappings

### Firestore Collections Schema

#### Users Collection
```json
{
  "uid": "string",
  "email": "string",
  "displayName": "string",
  "photoUrl": "string (optional)",
  "phoneNumber": "string (optional)",
  "role": "string (admin|treasurer|secretary|member)",
  "status": "string (active|inactive|suspended|deleted)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "lastLogin": "timestamp (optional)",
  "deletedAt": "timestamp (optional)"
}
```

#### Members Collection
```json
{
  "uid": "string",
  "displayName": "string",
  "email": "string",
  "phoneNumber": "string (optional)",
  "photoUrl": "string (optional)",
  "address": "string (optional)",
  "city": "string (optional)",
  "state": "string (optional)",
  "zipCode": "string (optional)",
  "membershipDate": "timestamp (optional)",
  "emergencyContact": "string (optional)",
  "emergencyPhone": "string (optional)",
  "role": "string",
  "status": "string",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "deletedAt": "timestamp (optional)"
}
```

## Architecture Patterns

### Clean Architecture
The project follows Clean Architecture principles with clear separation of concerns:
- **Presentation Layer**: UI components, screens, widgets
- **Domain Layer**: Business logic, use cases
- **Data Layer**: Repositories, data sources, models

### MVVM Pattern
- **Model**: Data classes and domain models
- **View**: Flutter widgets and screens
- **ViewModel**: Riverpod providers for state management

### Repository Pattern
Data access is abstracted through repositories, allowing easy switching between local and remote data sources.

## State Management with Riverpod

The application uses Riverpod for efficient, type-safe state management:

```dart
// Example: Watching all members
final membersAsync = ref.watch(membersStreamProvider);

// Example: Calling async function
final loginResult = await ref.read(
  loginProvider((email, password)).future,
);
```

## Offline Support

Hive local storage provides offline support for:
- Authentication tokens
- User preferences
- Application state
- Cached member data

## Code Quality

- **Linting**: Flutter and Dart lints configured
- **Error Handling**: Comprehensive error handling with Result type
- **Type Safety**: Full null safety and type checking
- **Documentation**: Inline comments and doc strings

## API Reference

### Authentication Service
```dart
// Sign up new user
final result = await authService.signUp(
  email: 'user@example.com',
  password: 'SecurePass123',
  displayName: 'John Doe',
);

// Sign in
final result = await authService.signIn(
  email: 'user@example.com',
  password: 'SecurePass123',
);

// Sign out
await authService.signOut();

// Reset password
await authService.resetPassword(email: 'user@example.com');
```

### Members Repository
```dart
// Get all members
final result = await membersRepository.getAllMembers();

// Get member by ID
final result = await membersRepository.getMemberById(memberId);

// Get members by role
final result = await membersRepository.getMembersByRole(UserRole.admin);

// Create member
await membersRepository.createMember(memberModel);

// Update member
await membersRepository.updateMember(memberModel);

// Delete member
await membersRepository.deleteMember(memberId);
```

## Development

### Running Tests
```bash
flutter test
```

### Building for Production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### Code Generation
```bash
flutter pub run build_runner build
```

## Troubleshooting

### Common Issues

1. **Firebase initialization error**
   - Ensure `firebase_options.dart` has correct credentials
   - Verify Android/iOS app registration in Firebase Console

2. **Firestore permission denied**
   - Check Firestore security rules
   - Ensure user is authenticated

3. **Hive initialization error**
   - Ensure `LocalStorageService.initialize()` is called in main.dart

## Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support and questions, please open an issue on GitHub.

## Changelog

### Phase 1: Initial Setup
- Flutter project structure
- Firebase configuration
- Riverpod setup
- GoRouter configuration
- Theme and styling

### Phase 2: Authentication
- User authentication service
- Login screen
- Sign up screen
- Password reset screen
- User model and providers

### Phase 3: Dashboard & Member Management
- Dashboard with statistics
- Members list with filtering
- Member details screen
- Real-time member updates

---

**Last Updated**: June 13, 2026
**Version**: 1.0.0
