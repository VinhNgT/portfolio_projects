import 'package:dio/dio.dart';
import 'package:e_commerce/logging/logger_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

/// Provides the instance of [Dio].
///
/// This [Dio] instance will be used to handle all network requests in the app.
@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  final dio = Dio();
  final logger = ref.watch(loggerProvider);

  dio.interceptors.addAll([
    LogInterceptor(),
    DataLogIntercepter(logger),
  ]);

  ref.onDispose(dio.close);
  return dio;
}

/// Interceptor to log sensitive data using [Logger].
class DataLogIntercepter extends Interceptor {
  const DataLogIntercepter(this.logger);
  final Logger logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.queryParameters.isNotEmpty) {
      debugPrint('Query Parameters:');
      logger.i(options.queryParameters);
    }

    if (options.data != null) {
      debugPrint('Request Data:');
      logger.i(options.data);
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('Response Data:');
    logger.i(response);

    handler.next(response);
  }
}
