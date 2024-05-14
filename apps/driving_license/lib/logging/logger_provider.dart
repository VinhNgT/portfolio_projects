import 'package:driving_license/constants/app_flavor.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger_provider.g.dart';

@Riverpod(keepAlive: true)
Logger logger(LoggerRef ref) {
  final logger = Logger(
    filter: DevelopmentFlavorFilter(),
  );

  ref.onDispose(logger.close);
  return logger;
}

class DevelopmentFlavorFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return appFlavor == AppFlavor.dev.name && event.level.value >= level!.value;
  }
}
