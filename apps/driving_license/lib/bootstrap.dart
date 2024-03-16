import 'dart:ui';

import 'package:driving_license/app.dart';
import 'package:driving_license/exceptions/async_error_logger.dart';
import 'package:driving_license/exceptions/error_logger.dart';
import 'package:driving_license/features/questions/data/question/question_repository.dart';
import 'package:driving_license/features/questions/data/question/sqlite_question_repository.dart';
import 'package:driving_license/features/questions/data/user_answer/user_answer_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Bootstrap {
  static Future<Widget> initApp() async {
    final container = await _createProviderContainer();
    return createRootWidget(container);
  }

  static Future<ProviderContainer> _createProviderContainer() async {
    // Load question database
    final sqliteQuestionRepository =
        await SqliteQuestionRepository.makeDefault();
    final userAnswerRepository = await UserAnswerRepository.makeDefault();

    final container = ProviderContainer(
      overrides: [
        questionRepositoryProvider.overrideWithValue(sqliteQuestionRepository),
        userAnswerRepositoryProvider.overrideWithValue(userAnswerRepository),
      ],
    );

    return container;
  }

  @protected
  static Future<UncontrolledProviderScope> createRootWidget(
    ProviderContainer container,
  ) async {
    _setupErrorHandlers(container);
    return UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    );
  }

  static void _setupErrorHandlers(ProviderContainer container) {
    final errorLogger = container.read(consoleErrorLoggerProvider);

    // Log all asynchronous errors
    container.observers.addAll([
      AsyncErrorLogger(errorLogger),
      // ProviderDebugObserver(),
    ]);

    // Show some error UI if any uncaught exception happens
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      errorLogger.logError(details.exception, details.stack);
    };

    // Handle errors from the underlying platform/OS
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      errorLogger.logError(error, stack);
      return true;
    };

    // Show some error UI when any widget in the app fails to build
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('An error occurred'),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }
}
