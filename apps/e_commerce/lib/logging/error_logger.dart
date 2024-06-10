import 'package:e_commerce/exceptions/app_exceptions.dart';
import 'package:logger/logger.dart';

/// A logger that logs all errors and exceptions in the app.
class ErrorLogger {
  ErrorLogger(this.logger);
  final Logger logger;

  void log(Object error, StackTrace? stackTrace) {
    switch (error) {
      case (final AppException exception):
        logger.w('App exception', error: exception, stackTrace: stackTrace);

      case _:
        logger.e('Unexpected error', error: error, stackTrace: stackTrace);
    }
  }
}
