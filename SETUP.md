# CMG System - Setup & Configuration Guide

## Project Overview

CMG System is a production-ready Flutter Android application for community management with:
- Firebase backend integration
- Real-time data synchronization
- Role-based access control
- Offline-first design with Hive

## Initial Setup Instructions

### 1. Firebase Project Configuration

#### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: "CMG System"
4. Accept Firebase terms and continue

#### Step 2: Register Android App
1. In Firebase Console, click "Add app"
2. Select Android
3. Enter Package Name: `com.example.cmg_system`
4. Enter App Nickname: "CMG System Android"
5. Download `google-services.json`
6. Place it in `android/app/`

#### Step 3: Enable Firebase Services

**Authentication**:
1. Go to Authentication section
2. Click "Get Started"
3. Enable "Email/Password" provider
4. Enable "Google" provider (optional)

**Firestore Database**:
1. Go to Firestore Database section
2. Click "Create database"
3. Start in production mode
4. Select region (closest to your users)

**Storage**:
1. Go to Storage section
2. Click "Get started"
3. Accept default rules for now

#### Step 4: Update Firebase Options

Update `lib/firebase_options.dart` with your Firebase credentials:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'cmg-system-xxxxx',
  storageBucket: 'cmg-system-xxxxx.appspot.com',
);
```

### 2. Flutter Setup

#### Install Dependencies
```bash
flutter pub get
```

#### Build Code Generation
```bash
flutter pub run build_runner build
```

### 3. Firestore Security Rules

Add these rules in Firebase Console:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read their own user document
    match /users/{uid} {
      allow read: if request.auth.uid == uid;
      allow write: if request.auth.uid == uid;
    }
    
    // Allow reading members (adjust based on your requirements)
    match /members/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'treasurer'];
    }
    
    // Admin-only collections
    match /roles/{document=**} {
      allow read, write: if request.auth != null && 
                          get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    match /permissions/{document=**} {
      allow read, write: if request.auth != null && 
                          get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

### 4. Create Firestore Collections

Create the following collections in Firestore:

**1. users**
- Document ID: Auto-generated
- Fields: uid, email, displayName, role, status, createdAt, updatedAt

**2. members**
- Document ID: Auto-generated
- Fields: uid, displayName, email, role, status, membershipDate, etc.

**3. roles**
- Document ID: role name (admin, treasurer, secretary, member)
- Fields: name, permissions, description

### 5. Test Credentials

Create test users in Firebase Console:

**Admin User**
- Email: admin@cmgsystem.com
- Password: AdminPassword123!
- Role: admin

**Treasurer User**
- Email: treasurer@cmgsystem.com
- Password: TreasurerPassword123!
- Role: treasurer

**Secretary User**
- Email: secretary@cmgsystem.com
- Password: SecretaryPassword123!
- Role: secretary

**Regular Member**
- Email: member@cmgsystem.com
- Password: MemberPassword123!
- Role: member

## Development Environment

### Required Tools
- Flutter 3.16.0+
- Dart 3.0.0+
- Android SDK (API Level 30+)
- Android Studio / VS Code with Flutter extension

### IDE Setup

**VS Code**:
1. Install Flutter extension
2. Install Dart extension
3. Configure Dart formatting (Optional)

**Android Studio**:
1. Install Flutter plugin
2. Install Dart plugin
3. Configure SDK paths

## Running the Application

### Development
```bash
flutter run
```

### Release
```bash
flutter run --release
```

### Debug Mode
```bash
flutter run -v
```

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS IPA
```bash
flutter build ios --release
```

## Environment Variables

Create a `.env` file in the root directory:

```
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
FIREBASE_APP_ID=your-app-id
```

## Debugging

### Enable Debug Logging
```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable debug logging
  FirebaseAuth.instance.setLanguageCode('en');
  
  await Firebase.initializeApp();
}
```

### Hot Reload
- Press 'R' in the terminal during `flutter run`
- Or use IDE shortcut (Ctrl+Shift+R / Cmd+Shift+R)

### Hot Restart
- Press 'r' in the terminal during `flutter run`

## Performance Optimization

### Firestore Query Optimization
1. Create composite indexes for complex queries
2. Use pagination for large datasets
3. Implement caching with Hive

### Image Optimization
1. Use cached_network_image for network images
2. Implement image compression
3. Use appropriate image sizes

## Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## Troubleshooting

### Issue: "Firebase not initialized"
**Solution**: Ensure `Firebase.initializeApp()` is called before any Firebase operations.

### Issue: "Firestore permission denied"
**Solution**: Check security rules and ensure user is authenticated.

### Issue: "Hive box not initialized"
**Solution**: Ensure `LocalStorageService.initialize()` is called in main.dart.

### Issue: "GoRouter routing error"
**Solution**: Verify all routes are properly defined and middleware is configured.

## Version History

- **1.0.0** (June 13, 2026) - Initial release
  - Phase 1: Project structure and Firebase setup
  - Phase 2: Complete authentication module
  - Phase 3: Dashboard and member management

## Next Steps

1. Customize branding and colors in `app_colors.dart`
2. Add your logo and assets
3. Configure push notifications (optional)
4. Set up analytics and crashlytics
5. Implement additional features as needed

## Support & Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [GoRouter Documentation](https://pub.dev/packages/go_router)

---

**For questions or issues, please refer to the README.md or open an issue on GitHub.**
