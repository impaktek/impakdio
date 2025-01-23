import 'package:impakdio/config/exceptions/impakdio_exceptions.dart';

// ignore_for_file: overridden_field
/// A sealed base class representing a generic response.
///
/// This class serves as the foundation for all response types in the application.
/// It encapsulates the response data, error details, and HTTP status code.
///
/// [T] is the type of data returned in the response.
sealed class ImpakdioResponse<T> {
  /// The data returned in the response, if available.
  final T? success;

  /// The error details associated with the response, if any.
  final dynamic failure;

  /// The HTTP status code of the response, if applicable.
  int? statusCode;

  /// Creates an [ImpakdioResponse] with the given [statusCode], [data], and [error].
  ///
  /// - [statusCode] is required.
  /// - [data] and [error] are optional.
  ImpakdioResponse({
    required this.statusCode,
    this.success,
    this.failure,
  });

  /// Returns `true` if the response is successful and contains data.
  bool get isSuccessful => success != null;
}

/// A specific implementation of [ImpakdioResponse] for dynamic data.
///
/// This class is useful for generic operations where the type of data
/// is not known at compile time.
class ImpakResponse extends ImpakdioResponse<dynamic> {
  final dynamic data;
  final dynamic error;
  /// Creates an [ImpakResponse] with the given [statusCode], [data], and [error].
  ImpakResponse({required super.statusCode, this.data, this.error}): super(success: data, failure: error);
}

/// Represents a successful response with typed data.
///
/// [T] is the type of data returned in the response.
class ImpakdioSuccess<T> extends ImpakdioResponse<T> {
  /// The data returned in the successful response.
  /// // ignore: overridden_field
  final T data;

  /// Creates an [ImpakdioSuccess] with the given [statusCode] and [data].
  ///
  /// - [statusCode] is required.
  /// - [data] is required and represents the successful result.
  ImpakdioSuccess({
    required super.statusCode,
    required this.data,
  }) : super(success: data);
}

/// Represents a response that indicates a failure without a valid result.
///
/// This class is useful for scenarios where an operation fails but does not throw an exception.
class ImpakdioFailure extends ImpakdioResponse<Never> {
  /// The error details associated with the failure.
  final dynamic error;

  /// Creates an [ImpakdioFailure] with the given [statusCode] and [error].
  ///
  /// - [statusCode] is required.
  /// - [error] is required and describes the failure.
  ImpakdioFailure({
    required super.statusCode,
    required this.error,
  });
}

/// Represents a response that encapsulates an exception.
///
/// This class is useful for scenarios where a specific [ImpakdioException]
/// provides more context about the error.
class ImpakdioError extends ImpakdioResponse<Never> {
  /// The exception associated with the error.
  final ImpakdioException exception;


  /// Creates an [ImpakdioError] with the given [statusCode] and [exception].
  ///
  /// - [statusCode] is required.
  /// - [exception] is required and provides details about the error.
  ImpakdioError({
    required super.statusCode,
    required this.exception,
  });
}
