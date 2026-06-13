import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Extension on Result type for convenient error handling
extension ResultExt<L, R> on Result<L, R> {
  /// Fold result into a single value
  T fold<T>(
    T Function(L left) ifLeft,
    T Function(R right) ifRight,
  ) =>
      _foldHelper(ifLeft, ifRight);

  T _foldHelper<T>(
    T Function(L) ifLeft,
    T Function(R) ifRight,
  ) {
    if (this is Left<L, R>) {
      return ifLeft((this as Left<L, R>).value);
    } else {
      return ifRight((this as Right<L, R>).value);
    }
  }

  /// Get right value or null
  R? getOrNull() => fold((l) => null, (r) => r);

  /// Get left value or null
  L? leftOrNull() => fold((l) => l, (r) => null);

  /// Check if result is right
  bool get isRight => fold((l) => false, (r) => true);

  /// Check if result is left
  bool get isLeft => fold((l) => true, (r) => false);

  /// Map right value
  Result<L, T> mapRight<T>(T Function(R) mapper) {
    return fold(
      (left) => Left<L, T>(left),
      (right) => Right<L, T>(mapper(right)),
    );
  }

  /// Map left value
  Result<T, R> mapLeft<T>(T Function(L) mapper) {
    return fold(
      (left) => Left<T, R>(mapper(left)),
      (right) => Right<T, R>(right),
    );
  }
}

/// Left side of Either/Result type
class Left<L, R> implements Result<L, R> {
  final L value;

  const Left(this.value);

  @override
  String toString() => 'Left($value)';
}

/// Right side of Either/Result type
class Right<L, R> implements Result<L, R> {
  final R value;

  const Right(this.value);

  @override
  String toString() => 'Right($value)';
}

/// Result type for functional error handling
abstract class Result<L, R> {
  factory Result.left(L value) = Left<L, R>;
  factory Result.right(R value) = Right<L, R>;
}

/// Widget helper for handling async results
class AsyncResultBuilder<T> extends StatelessWidget {
  final AsyncValue<T> asyncValue;
  final Widget Function(T data) onData;
  final Widget Function(Object error, StackTrace stack) onError;
  final Widget Function() onLoading;

  const AsyncResultBuilder({
    Key? key,
    required this.asyncValue,
    required this.onData,
    required this.onError,
    required this.onLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: onData,
      loading: onLoading,
      error: onError,
    );
  }
}
