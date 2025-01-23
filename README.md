# Impakdio

`Impakdio` is a Dart library designed for making type-safe HTTP requests with support for authentication, logging, timeouts, error handling, and cancellation. It provides a flexible and structured way to handle various HTTP operations, including GET, POST, PUT, PATCH, and DELETE requests. With its built-in handling for timeouts, errors, and retries, `Impakdio` simplifies your networking tasks.

## Features

- **Type-Safe Responses**: Automatically parses JSON responses into Dart objects.
- **Authentication Support**: Easily set and use authentication tokens in requests.
- **Error Handling**: Handles common HTTP errors like timeout, cancellation, and authorization failures.
- **Logging**: Optionally log all request and response details for debugging.
- **Timeout Handling**: Configurable request timeouts with various time units.
- **Request Cancellation**: Cancel in-progress requests.
- **Customizable HTTP Methods**: Supports GET, POST, PUT, PATCH, and DELETE methods.
- **Flexible Base URL Configuration**: Allows setting a base URL for all requests.

## Installation

To use `Impakdio`, add it as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  impakdio: ^1.0.0
```

Then run `flutter pub get` to install the package.

## Usage

### Initial Setup

Before making any requests, initialize the base URL for the API you are working with:

```dart
import 'package:impakdio/impakdio.dart';

// Initialize the base URL
Impakdio.instance.initBaseUrl("https://yourapi.com");
```

You can also set the authentication token globally if your API requires authentication:

```dart
Impakdio.setAuthenticationToken('your-auth-token');
```

### Making Requests

The `Impakdio` class provides a `typeSafeCall` method for making type-safe HTTP requests.

#### Example: Making a GET Request

```dart
import 'package:impakdio/impakdio.dart';

// Define a function to parse the response into a custom model
YourModel parseResponse(dynamic data) {
  return YourModel.fromJson(data);
}

// Make a GET request
Future<void> fetchData() async {
  try {
    final response = await Impakdio.instance.typeSafeCall<YourModel>(
      path: '/your-endpoint',
      successFromJson: parseResponse,
    );

    // Handle the successful response
    if (response is ImpakdioSuccess) {
      print('Data: ${response.data}');
    } else {
      print('Error: ${response.error}');
    }
  } catch (e) {
    print('Request failed: $e');
  }
}
```

#### Example: Making a POST Request

```dart
import 'package:impakdio/impakdio.dart';

// Define your body data
Map<String, dynamic> bodyData = {'key': 'value'};

// Make a POST request
Future<void> postData() async {
  try {
    final response = await Impakdio.instance.typeSafeCall<YourModel>(
      path: '/your-endpoint',
      successFromJson: parseResponse,
      method: RequestMethod.POST,
      body: bodyData,
    );

    // Handle the successful response
    if (response is ImpakdioSuccess) {
      print('Data: ${response.data}');
    } else {
      print('Error: ${response.error}');
    }
  } catch (e) {
    print('Request failed: $e');
  }
}
```

### Request Configuration

The `typeSafeCall` method accepts several parameters to customize the request:

- **`path`**: The relative path of the endpoint (e.g., `/users`).
- **`successFromJson`**: A function that maps the response data to a Dart object.
- **`headers`**: Optional custom headers.
- **`queryParams`**: Optional query parameters.
- **`baseUrl`**: Optionally override the default base URL for this request.
- **`useAuthorization`**: Whether to use the global authorization token.
- **`authorizationToken`**: Optionally provide a custom authorization token.
- **`useLogger`**: Whether to log request and response details.
- **`timeout`**: Request timeout in seconds (default: 60).
- **`timeUnit`**: The unit of time for the timeout (default: `TimeUnit.SECONDS`).
- **`formData`**: Optional form data for multipart requests.
- **`method`**: The HTTP method to use (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`).
- **`body`**: The request body for `POST`, `PUT`, or `PATCH` methods.

### Error Handling

`Impakdio` has built-in error handling for various HTTP exceptions:

- **Timeout**: If the request takes too long, a `TIMEOUT_ERROR` will be thrown.
- **Authorization**: If the server returns a 401 status code, an `AUTHORIZATION_ERROR` is thrown.
- **Cancellation**: If the request is cancelled by the user, a `CANCELLED_ERROR` is thrown.
- **Server Errors**: Handles various server errors, such as 500 status codes.

### Response Handling

When making a request, the response is wrapped in an `ImpakdioResponse` object, which could be one of the following:

- **`ImpakdioSuccess`**: Contains the parsed data if the request is successful.
- **`ImpakdioFailure`**: Contains an error message if the request fails but doesn’t throw an exception.
- **`ImpakdioError`**: Contains error details when an exception is caught during the request.

### Cancel a Request

You can cancel an ongoing request by passing `withCancelToken: true` in the request options. This will allow you to cancel the request before it completes.

```dart
import 'package:impakdio/impakdio.dart';

CancelToken cancelToken = CancelToken();

// Cancel a request at any time
cancelToken.cancel();
```

### Timeout Handling

You can configure a timeout for your requests by setting the `timeout` parameter. The default is 60 seconds.

```dart
import 'package:impakdio/impakdio.dart';

// Set a custom timeout
Impakdio.instance.typeSafeCall(
  path: '/your-endpoint',
  timeout: 30,  // Timeout in seconds
);
```

## Exceptions

`Impakdio` uses a custom exception class (`ImpakdioException`) for error reporting. The exception contains detailed information about the error, including:

- **`ExceptionType`**: The type of exception (e.g., `TIMEOUT_ERROR`, `BAD_REQUEST`, `SERVER_ERROR`).
- **`message`**: A detailed error message.
- **`statusCode`**: The HTTP status code associated with the error (if available).

## Advanced Configuration

You can further customize the request by using additional parameters, such as:

- **`headers`**: Add custom headers for specific requests.
- **`queryParams`**: Add query parameters for the request URL.
- **`formData`**: If you need to send multipart data, pass `FormData` as the body.
- **`method`**: Specify the HTTP method (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
# impakdio
