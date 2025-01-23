import 'package:dio/dio.dart';
import 'package:impakdio/config/time_units.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// An abstract class for managing network configurations in a Dio-based HTTP client.
///
/// This class allows customization of network settings such as timeouts,
/// base URL, and optional headers. It also supports logging and time unit conversions.
abstract class NetworkConfig {
  /// The read timeout for network requests in seconds or milliseconds (default is 30 seconds).
  int _readTimeout = 30;

  /// Sets the read timeout. Throws an exception if the value is less than 0.
  set readTimeout(int? value) {
    if (value != null && value < 0) {
      throw ("Read timeout must be greater than 0");
    }
    _readTimeout = value ?? _readTimeout;
  }

  /// Gets the current read timeout value.
  int get readTimeout => _readTimeout;

  /// The connection timeout for network requests in seconds or milliseconds (default is 30 seconds).
  int _connectTimeout = 30;

  /// Sets the connection timeout. Throws an exception if the value is less than 0.
  set connectTimeout(int? value) {
    if (value != null && value < 0) {
      throw ("Connection timeout must be greater than 0");
    }
    _connectTimeout = value ?? _connectTimeout;
  }

  /// Gets the current connection timeout value.
  int get connectTimeout => _connectTimeout;

  /// The unit of time used for timeouts (default is seconds).
  TimeUnit timeUnit = TimeUnit.SECONDS;

  /// The base URL for the HTTP client.
  String? baseUrl;

  /// Generates Dio `BaseOptions` configured with the current network settings.
  BaseOptions get options => BaseOptions(
    connectTimeout: _getDuration(connectTimeout),
    receiveTimeout: _getDuration(readTimeout),
    //validateStatus: (_)=> true,
    //baseUrl: baseUrl!,
    contentType: 'application/json',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  /// Converts the timeout value into a `Duration` based on the selected time unit.
  Duration _getDuration(int value) {
    switch (timeUnit) {
      case TimeUnit.SECONDS:
        return Duration(seconds: value);
      case TimeUnit.MILLISECONDS:
        return Duration(milliseconds: value);
    }
  }

  /// Creates and configures a Dio client with optional headers, logging, and custom timeouts.
  ///
  /// Parameters:
  /// - [headers]: Additional headers to include in each request.
  /// - [useLogger]: Whether to enable logging of requests and responses (default is true).
  /// - [readTimeout]: Custom read timeout value.
  /// - [connectTimeout]: Custom connection timeout value.
  /// - [timeUnit]: Unit of time for timeouts (default is seconds).
  /// - [userAuth]: Placeholder for any user authentication logic (optional).
  ///
  /// Returns:
  /// - A configured instance of `Dio`.
  Dio client({
    Map<String, dynamic>? headers,
    bool useLogger = true,
    int? readTimeout,
    int? connectTimeout,
    TimeUnit timeUnit = TimeUnit.SECONDS,
    bool? userAuth,
  }) {
    // Update timeout values and time unit.
    this.readTimeout = readTimeout;
    this.connectTimeout = connectTimeout;
    this.timeUnit = timeUnit;

    // Initialize Dio with the configured options.
    final dio = Dio(options);

    // Add a logging interceptor if logging is enabled.
    if (useLogger) {
      dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: false,
      ));
    }

    // Add custom headers if provided.
    if (headers != null) {
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers.addAll(headers);
          return handler.next(options);
        },
      ));
    }

    return dio;
  }
}
