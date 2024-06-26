import 'package:flutter/material.dart';

/// Base class for all all client-side errors that can be generated by the app

@immutable
class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

class SubmitFeedbackFailedException extends AppException {
  const SubmitFeedbackFailedException(this.detail)
      : super('Failed to submit feedback: $detail');
  final String detail;
}
