import 'package:e_commerce/constants/app_flavors.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger_provider.g.dart';

@Riverpod(keepAlive: true)
Logger logger(LoggerRef ref) {
  final logger = Logger(
    filter: CombineFilter([
      DevelopmentFlavorFilter(),
    ]),
  );

  ref.onDispose(logger.close);
  return logger;
}

class CombineFilter extends LogFilter {
  CombineFilter(this.filters);
  final List<LogFilter> filters;

  @override
  bool shouldLog(LogEvent event) {
    return filters.every((filter) => filter.shouldLog(event));
  }
}

class DevelopmentFlavorFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return (appFlavor != AppFlavors.production) &&
        event.level.value >= level!.value;
  }
}
