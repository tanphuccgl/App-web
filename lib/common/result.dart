import 'package:flutter/services.dart';

enum TypeError { exception, network }

extension TypeErrorExt on TypeError {
  String get nameError {
    switch (this) {
      case TypeError.network:
        return "Error";
      default:
        return "Error";
    }
  }
}

class XResult<T> {
  T? data;
  String? error;

  bool get isError => error != null;
  bool get isSuccess => error == null && data != null;

  PageStatus get status {
    return isError ? PageStatus.error : PageStatus.success;
  }

  XResult.success(this.data) {
    this.error = null;
  }

  XResult.error(String? error) {
    this.data = null;
    this.error = error ?? TypeError.exception.nameError;
  }

  XResult.exception(Object? e) {
    this.data = null;
    if (e is PlatformException) {
      error = e.message;
    } else if (e is AssertionError) {
      error = e.message?.toString();
    }
    error ??= TypeError.exception.nameError;
  }
}

enum PageStatus { initial, loading, error, success }
