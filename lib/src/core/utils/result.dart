import 'package:fpdart/fpdart.dart';

class Failure {
  final String message;
  final String? code;
  final Exception? exception;

  const Failure({
    required this.message,
    this.code,
    this.exception,
  });

  factory Failure.fromException(Exception e) {
    return Failure(
      message: e.toString(),
      exception: e,
    );
  }

  @override
  String toString() => 'Failure: $message (code: $code)';
}

typedef Result<T> = Either<Failure, T>;
