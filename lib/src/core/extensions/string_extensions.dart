extension StringExtensions on String {
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool get isValidPassword {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 digit
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@\$!%*?&]{8,}$',
    );
    return passwordRegex.hasMatch(this);
  }

  bool get isValidPhoneNumber {
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    return phoneRegex.hasMatch(replaceAll(RegExp(r'[^0-9]'), ''));
  }

  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String capitalizeWords() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  bool get isNullOrEmpty => isEmpty;
}
