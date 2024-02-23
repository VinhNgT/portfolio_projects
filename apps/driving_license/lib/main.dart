import 'dart:ui';

import 'package:driving_license/app.dart';
import 'package:driving_license/exceptions/async_error_logger.dart';
import 'package:driving_license/exceptions/error_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  // Firebase needs this to be called before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Create custom provider container
  // This can be used to override repositories with fake ones for testing or
  // during development
  final container = ProviderContainer(
    overrides: [
      // localCartRepositoryProvider.overrideWithValue(localCartRepository),
    ],
  );

  // Register the error logger and the error handlers
  final errorLogger = container.read(consoleErrorLoggerProvider);
  container.observers.add(AsyncErrorLogger(errorLogger));
  registerErrorHandlers(errorLogger);

  // Start the app
  await setSystemChrome();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

void registerErrorHandlers(ErrorLogger errorLogger) {
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

Future<void> setSystemChrome() async {
  // Lock device orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarBrightness: Brightness.light,
  //     statusBarIconBrightness: Brightness.dark,
  //     statusBarColor: Colors.transparent,
  //     systemNavigationBarColor: Colors.transparent,
  //   ),
  // );

  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}
