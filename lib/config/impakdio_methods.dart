part of '../impakdio.dart';

/// A utility class that provides network methods for making HTTP requests
/// such as `GET`, `POST`, `PUT`, `PATCH`, and `DELETE`.
/// This class extends the `NetworkConfig` to leverage configurations such as
/// headers, timeouts, and logging for HTTP requests.
///
/// Each method uses the `Dio` library for HTTP calls and allows customization
/// of parameters like headers, query parameters, body, and more.
class _ImpactMethods extends NetworkConfig {

  /// Sends an HTTP `GET` request to the specified URL.
  ///
  /// - [url]: The endpoint URL to send the request to.
  /// - [headers]: The headers to include in the request.
  /// - [params]: The query parameters for the request.
  /// - [cancelToken]: A `CancelToken` to cancel the request if needed.
  /// - [authorizationToken]: Optional authorization token to be used in the headers.
  /// - [useLogger]: Whether to enable logging for the request. Defaults to `true`.
  /// - [timeout]: The timeout duration for the request, in seconds. Defaults to `60`.
  /// - [timeUnit]: The unit of time for the timeout, such as `SECONDS`. Defaults to `TimeUnit.SECONDS`.
  /// 
  /// Returns a `Response` object containing the server's response.
  /// Throws an exception if the request fails.
  Future<Response<dynamic>> get({
    required String url,
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> params = const {},
    CancelToken? cancelToken,
    String? authorizationToken,
    bool useLogger = true,
    int timeout = 60,
    TimeUnit timeUnit = TimeUnit.SECONDS,
  }) async {
    final dio = client(
      useLogger: useLogger,
      headers: headers,
      timeUnit: timeUnit,
      connectTimeout: timeout,
      readTimeout: timeout,
    );
    final result = await dio.get(url, queryParameters: params, cancelToken: cancelToken);
    return result;
  }

  /// Sends an HTTP `POST` request to the specified URL.
  ///
  /// - [url]: The endpoint URL to send the request to.
  /// - [headers]: The headers to include in the request.
  /// - [param]: Optional query parameters for the request.
  /// - [body]: The body data to include in the request.
  /// - [cancelToken]: A `CancelToken` to cancel the request if needed.
  /// - [useLogger]: Whether to enable logging for the request. Defaults to `true`.
  /// - [timeout]: The timeout duration for the request, in seconds. Defaults to `60`.
  /// - [timeUnit]: The unit of time for the timeout, such as `SECONDS`. Defaults to `TimeUnit.SECONDS`.
  ///
  /// Returns a `Response` object containing the server's response.
  /// Throws an exception if the request fails.
  Future<Response<dynamic>> post({
    required String url,
    Map<String, dynamic> headers = const {},
    Map<String, dynamic>? param,
    Object? body,
    CancelToken? cancelToken,
    bool useLogger = true,
    int timeout = 60,
    TimeUnit timeUnit = TimeUnit.SECONDS,
  }) async {
    final dio = client(
      useLogger: useLogger,
      headers: headers,
      timeUnit: timeUnit,
      connectTimeout: timeout,
      readTimeout: timeout,
    );
    final result = await dio.post(url, data: body, queryParameters: param, cancelToken: cancelToken);
    return result;
  }

  /// Sends an HTTP `PUT` request to the specified URL.
  ///
  /// - [url]: The endpoint URL to send the request to.
  /// - [headers]: The headers to include in the request.
  /// - [param]: Optional query parameters for the request.
  /// - [body]: The body data to include in the request.
  /// - [cancelToken]: A `CancelToken` to cancel the request if needed.
  /// - [useLogger]: Whether to enable logging for the request. Defaults to `true`.
  /// - [timeout]: The timeout duration for the request, in seconds. Defaults to `60`.
  /// - [timeUnit]: The unit of time for the timeout, such as `SECONDS`. Defaults to `TimeUnit.SECONDS`.
  ///
  /// Returns a `Response` object containing the server's response.
  /// Throws an exception if the request fails.
  Future<Response<dynamic>> put({
    required String url,
    Map<String, dynamic> headers = const {},
    Map<String, dynamic>? param,
    Object? body,
    CancelToken? cancelToken,
    bool useLogger = true,
    int timeout = 60,
    TimeUnit timeUnit = TimeUnit.SECONDS,
  }) async {
    final dio = client(
      useLogger: useLogger,
      headers: headers,
      timeUnit: timeUnit,
      connectTimeout: timeout,
      readTimeout: timeout,
    );
    final result = await dio.put(url, data: body, queryParameters: param, cancelToken: cancelToken);
    return result;
  }

  /// Sends an HTTP `PATCH` request to the specified URL.
  ///
  /// - [url]: The endpoint URL to send the request to.
  /// - [headers]: The headers to include in the request.
  /// - [param]: Optional query parameters for the request.
  /// - [body]: The body data to include in the request.
  /// - [cancelToken]: A `CancelToken` to cancel the request if needed.
  /// - [useLogger]: Whether to enable logging for the request. Defaults to `true`.
  /// - [timeout]: The timeout duration for the request, in seconds. Defaults to `60`.
  /// - [timeUnit]: The unit of time for the timeout, such as `SECONDS`. Defaults to `TimeUnit.SECONDS`.
  ///
  /// Returns a `Response` object containing the server's response.
  /// Throws an exception if the request fails.
  Future<Response<dynamic>> patch({
    required String url,
    Map<String, dynamic> headers = const {},
    Map<String, dynamic>? param,
    Object? body,
    CancelToken? cancelToken,
    bool useLogger = true,
    int timeout = 60,
    TimeUnit timeUnit = TimeUnit.SECONDS,
  }) async {
    final dio = client(
      useLogger: useLogger,
      headers: headers,
      timeUnit: timeUnit,
      connectTimeout: timeout,
      readTimeout: timeout,
    );
    final result = await dio.patch(url, data: body, queryParameters: param, cancelToken: cancelToken);
    return result;
  }

  /// Sends an HTTP `DELETE` request to the specified URL.
  ///
  /// - [url]: The endpoint URL to send the request to.
  /// - [headers]: The headers to include in the request.
  /// - [param]: Optional query parameters for the request.
  /// - [body]: The body data to include in the request.
  /// - [cancelToken]: A `CancelToken` to cancel the request if needed.
  /// - [useLogger]: Whether to enable logging for the request. Defaults to `true`.
  /// - [timeout]: The timeout duration for the request, in seconds. Defaults to `60`.
  /// - [timeUnit]: The unit of time for the timeout, such as `SECONDS`. Defaults to `TimeUnit.SECONDS`.
  ///
  /// Returns a `Response` object containing the server's response.
  /// Throws an exception if the request fails.
  Future<Response<dynamic>> delete({
    required String url,
    Map<String, dynamic> headers = const {},
    Map<String, dynamic>? param,
    Object? body,
    CancelToken? cancelToken,
    bool useLogger = true,
    int timeout = 60,
    TimeUnit timeUnit = TimeUnit.SECONDS,
  }) async {
    final dio = client(
      useLogger: useLogger,
      headers: headers,
      timeUnit: timeUnit,
      connectTimeout: timeout,
      readTimeout: timeout,
    );
    final result = await dio.delete(url, data: body, queryParameters: param, cancelToken: cancelToken);
    return result;
  }
}
