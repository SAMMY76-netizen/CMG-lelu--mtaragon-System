import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'CMG System';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Community Management System';

  // API Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Pagination
  static const int pageSize = 20;
  static const int defaultPageSize = 10;

  // Local Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userRoleKey = 'user_role';
  static const String userDataKey = 'user_data';
  static const String lastLoginKey = 'last_login';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxDisplayNameLength = 100;
  static const int maxEmailLength = 254;

  // UI Dimensions
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double defaultElevation = 2.0;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 1000);

  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 1);
  static const Duration shortCacheDuration = Duration(minutes: 5);
  static const Duration longCacheDuration = Duration(days: 7);
}
