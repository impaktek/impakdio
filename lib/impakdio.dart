library impakdio;

import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:impakdio/config/exceptions/impakdio_exceptions.dart';
import 'package:impakdio/config/impakdio_response.dart';
import 'package:impakdio/config/network_config.dart';

import 'config/request_methods.dart';
import 'config/time_units.dart';

part 'config/impakdio_methods.dart';

/// A class for making HTTP requests with type-safe handling of API responses.
/// The `Impakdio` class encapsulates the logic for making network requests,
/// handling timeouts, logging, authentication, error handling, and response parsing.
class Impakdio {
  /// The base URL for the API requests. This can be initialized using [initBaseUrl].
  String? baseUrl;

  /// A private static variable to store the global authentication token.
  static String? _authenticationToken;

  /// An instance of the `_ImpactMethods` class, which contains the methods for making actual HTTP requests.
  final methods = _ImpactMethods();

  /// Private constructor for the singleton pattern. Ensures only one instance of `Impakdio`.
  Impakdio._internal();

  /// A static final instance of the `Impakdio` class, used globally for accessing the methods.
  static final instance = Impakdio._internal();

  /// Default constructor.
  Impakdio();

  /// Initializes the base URL for the API client.
  ///
  /// [baseUrl] the base URL to be used for making API requests.
  /// Throws a [FormatException] if the URL format is invalid.
  void initBaseUrl(String baseUrl) {
    this.baseUrl = _validateUrl(baseUrl);
  }

  /// Sets the authentication token for the API client.
  ///
  /// This token is used for authenticated requests where the server expects an authorization header.
  ///
  /// [token] the authentication token to be set.
  static setAuthenticationToken(String token) {
    _authenticationToken = token;
  }

  /// Validates that the provided URL is in a valid format.
  ///
  /// [url] the URL to be validated.
  ///
  /// Returns the valid URL if the format is correct.
  ///
  /// Throws a [FormatException] if the URL is not properly formatted (must start with `http://` or `https://` and must not end with a slash).
  String _validateUrl(String url) {
    final regex = RegExp(
        r'^(https?://)(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(:\d{1,5})?(?<!/)$');

    if (!regex.hasMatch(url)) {
      throw FormatException(
          "Invalid URL: $url. A valid base URL must start with 'http://' or 'https://', be followed by a valid domain name or IP address, and must not end with '/'.");
    }

    return url;
  }

  /// A cancel token used for cancelling ongoing requests.
  CancelToken? _cancelToken;

  /// Makes a type-safe API call and maps the successful response to the provided type [T].
  ///
  /// [path] the relative path to the API endpoint.
  /// [successFromJson] a function that maps the response data to the expected type [T].
  /// [headers] optional custom headers for the request.
  /// [queryParams] optional query parameters to be added to the request URL.
  /// [baseUrl] optional base URL to override the default.
  /// [withCancelToken] flag indicating if the request should support cancellation.
  /// [useAuthorization] flag indicating if the request should use the global authorization token.
  /// [authorizationToken] optional custom authorization token.
  /// [useLogger] flag to enable logging.
  /// [timeout] timeout duration in seconds.
  /// [timeUnit] the unit of time for the timeout (default is `TimeUnit.SECONDS`).
  /// [formData] optional form data for multipart requests.
  /// [method] the HTTP method for the request (GET, POST, PUT, PATCH, DELETE).
  /// [body] optional body data for POST, PUT, or PATCH requests.
  ///
  /// Returns a future containing the result of the API call, wrapped in an [ImpakdioResponse].
  Future<ImpakdioResponse<T>> typeSafeCall<T>({
    required String path,
    required T Function(dynamic) successFromJson,
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> queryParams = const {},
    String? baseUrl,
    bool withCancelToken = false,
    bool useAuthorization = false,
    String? authorizationToken,
    bool useLogger = true,
    int timeout = 60,
    TimeUnit timeUnit = TimeUnit.SECONDS,
    FormData? formData,
    required RequestMethod method,
    Map<String, dynamic>? body
  }) async {
    try {
      // Make the API call with the provided parameters.
      final result = await call(path: path,
          method: method,
          headers: headers,
          queryParams: queryParams,
          baseUrl: baseUrl,
          withCancelToken: withCancelToken,
          useAuthorization: useAuthorization,
          authorizationToken: authorizationToken,
          useLogger: useLogger,
          timeout: timeout,
          timeUnit: timeUnit,
          formData: formData,
          body: body
      );

      // If the result is successful, parse the data using the provided `successFromJson` function.
      if(result.isSuccessful){
        try {
          final data = successFromJson(result.data);
          return ImpakdioSuccess(data: data, statusCode: result.statusCode);
        } on Object catch(e, s){
          log(e.toString());
          log(s.toString());
          // If parsing fails, throw a mapping error.
          throw ImpakdioException(statusCode: result.statusCode, ExceptionType.MAPPING_ERROR, message: e.toString());
        }
      } else {
        // If the result is not successful, return an error response.
        return ImpakdioFailure(error: result.error, statusCode: result.statusCode);
      }

    } on ImpakdioException catch (e) {
      // Handle known exceptions and wrap them in an ImpakdioError.
      return ImpakdioError(exception: e, statusCode: e.statusCode);
    } catch(e){
      // If an unknown error occurs, wrap it in an ImpakdioError.
      return ImpakdioError(statusCode: null, exception: ImpakdioException(statusCode: null, ExceptionType.UNKNOWN_ERROR, message: e.toString()));
    }
  }

  /// Makes an actual API call with various configurations and parameters.
  ///
  /// [path] the relative path to the API endpoint.
  /// [headers] optional custom headers for the request.
  /// [queryParams] optional query parameters to be added to the request URL.
  /// [baseUrl] optional base URL to override the default.
  /// [withCancelToken] flag indicating if the request should support cancellation.
  /// [useAuthorization] flag indicating if the request should use the global authorization token.
  /// [authorizationToken] optional custom authorization token.
  /// [useLogger] flag to enable logging.
  /// [timeout] timeout duration in seconds.
  /// [timeUnit] the unit of time for the timeout (default is `TimeUnit.SECONDS`).
  /// [formData] optional form data for multipart requests.
  /// [method] the HTTP method for the request (GET, POST, PUT, PATCH, DELETE).
  /// [body] optional body data for POST, PUT, or PATCH requests.
  ///
  /// Returns a future containing the raw response from the API as an [ImpakResponse].
  Future<ImpakResponse> call({
    required String path,
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> queryParams = const {},
    String? baseUrl,
    bool withCancelToken = false,
    bool useAuthorization = false,
    String? authorizationToken,
    bool useLogger = true,
    int timeout = 60,
    TimeUnit timeUnit = TimeUnit.SECONDS,
    FormData? formData,
    required RequestMethod method,
    Map<String, dynamic>? body
  }) async {
    try {
      // If cancellation is enabled, cancel any previous requests.
      if (withCancelToken) {
        _cancelToken?.cancel();
        _cancelToken = CancelToken();
      }

      // Build the full URL for the request by appending the path to the base URL.
      final url = _pathBuilder(baseUrl, path);

      // If authorization is required, add the token to the request headers.
      if (useAuthorization || authorizationToken != null) {
        headers['Authorization'] = authorizationToken ?? _authenticationToken;
      }

      // Make the request using the appropriate HTTP method (GET, POST, PUT, PATCH, DELETE).
      final result = await switch(method) {
        RequestMethod.GET =>
            methods.get(url: url,
              headers: headers,
              useLogger: useLogger,
              timeout: timeout,
              timeUnit: timeUnit,
              params: queryParams,
              cancelToken: _cancelToken,),
        RequestMethod.POST =>
            methods.post(url: url,
                headers: headers,
                useLogger: useLogger,
                timeout: timeout,
                timeUnit: timeUnit,
                param: queryParams,
                cancelToken: _cancelToken,
                body: body ?? formData),
        RequestMethod.PUT =>
            methods.put(url: url,
                headers: headers,
                useLogger: useLogger,
                timeout: timeout,
                timeUnit: timeUnit,
                param: queryParams,
                cancelToken: _cancelToken,
                body: body ?? formData),
        RequestMethod.PATCH =>
            methods.patch(url: url,
                headers: headers,
                useLogger: useLogger,
                timeout: timeout,
                timeUnit: timeUnit,
                param: queryParams,
                cancelToken: _cancelToken,
                body: body ?? formData),
        RequestMethod.DELETE =>
            methods.delete(url: url,
                headers: headers,
                useLogger: useLogger,
                timeout: timeout,
                timeUnit: timeUnit,
                param: queryParams,
                cancelToken: _cancelToken,
                body: body ?? formData),
      };

      // Return the raw API response wrapped in an ImpakResponse.
      return ImpakResponse(statusCode: result.statusCode, data: result.data);
    } on TimeoutException catch (_){
      // Handle timeout errors and throw a specific timeout exception.
      throw(ImpakdioException(ExceptionType.TIMEOUT_ERROR, statusCode: null, message: "Request timed out"));
    } on DioException catch(e){
      // Handle different types of Dio errors and throw appropriate exceptions.
      if(e.type == DioExceptionType.cancel){
        throw(ImpakdioException(ExceptionType.CANCELLED_ERROR, message: "Request was cancelled by user", statusCode: e.response?.statusCode));
      }
      if(e.type == DioExceptionType.badResponse){
        final response = e.response;
        if(response?.statusCode == 401 || response?.statusCode == 403){
          throw(ImpakdioException(ExceptionType.AUTHORISATION_ERROR, message: "Unauthorized request", statusCode: e.response?.statusCode));
        }
        if(response != null){
          return ImpakResponse(error: e.response?.data, statusCode: e.response?.statusCode);
        }
        throw(ImpakdioException(ExceptionType.BAD_REQUEST, statusCode: e.response?.statusCode, message: "Server returned an error. Check server status"));
      }

      if(e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.sendTimeout){
        throw(ImpakdioException(ExceptionType.TIMEOUT_ERROR, message: "Request timed out", statusCode: e.response?.statusCode));
      }
      if(e.type == DioExceptionType.connectionError){
        throw(ImpakdioException(ExceptionType.CONNECTION_ERROR, message: "Failed to connect to server. Check internet connection", statusCode: e.response?.statusCode));
      }

      if(e.type == DioExceptionType.unknown){
        throw(ImpakdioException(ExceptionType.UNKNOWN_ERROR, message: "An unknown error occurred", statusCode: e.response?.statusCode));
      }

      throw(ImpakdioException(ExceptionType.SERVER_ERROR, message: "A server error occurred", statusCode: e.response?.statusCode));
    }

    on Object catch (exception) {
      // Handle any unexpected errors and wrap them in an unknown error exception.
      throw(ImpakdioException(ExceptionType.UNKNOWN_ERROR, message: exception.toString(), statusCode: null), statusCode: null);
    }
  }

  /// Builds the complete URL by appending the given path to the base URL.
  ///
  /// [baseUrl] the base URL to prepend (defaults to the instance's baseUrl).
  /// [path] the path to append to the base URL.
  ///
  /// Returns the full URL as a string.
  String _pathBuilder(String? baseUrl, String path) {
    final url = baseUrl ?? this.baseUrl;
    if (url == null) {
      throw Exception('No Base URL set');
    }
    final result = _validateUrl(url);
    return '$result${_formatPath(path)}';
  }

  /// Ensures that the path starts with a leading slash if it doesn't already.
  ///
  /// [path] the path to format.
  ///
  /// Returns the formatted path with a leading slash if necessary.
  String _formatPath(String path) {
    if (!path.startsWith('/')) {
      return '/$path';
    }
    return path;
  }
}
