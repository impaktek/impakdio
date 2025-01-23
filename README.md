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

## `call` Method

The `call` method is the core method in `Impakdio` for making HTTP requests to a remote API. It supports different HTTP request methods such as `GET`, `POST`, `PUT`, `PATCH`, and `DELETE`. This method provides a flexible way to manage request parameters, headers, timeouts, and more. It returns a dynamic response, allowing you to handle different types of API responses in a flexible manner.

### Method Signature
```dart
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
  Map<String, dynamic>? body,
});
```

### Parameters

- **`path`** (`String`): The endpoint path for the request. This is a required parameter.
- **`headers`** (`Map<String, dynamic>`): The HTTP headers to be sent with the request. Default is an empty map (`{}`).
- **`queryParams`** (`Map<String, dynamic>`): The query parameters to be appended to the URL. Default is an empty map (`{}`).
- **`baseUrl`** (`String?`): The base URL for the API. If not provided, it uses the base URL initialized using `initBaseUrl()`.
- **`withCancelToken`** (`bool`): If `true`, a cancel token will be created to allow canceling the request. Default is `false`.
- **`useAuthorization`** (`bool`): If `true`, the request will include an authorization token, either from the provided `authorizationToken` or the static `_authenticationToken`. Default is `false`.
- **`authorizationToken`** (`String?`): The authorization token to be included in the request headers. If not provided, it will fallback to `_authenticationToken` when `useAuthorization` is `true`.
- **`useLogger`** (`bool`): If `true`, the request and response will be logged for debugging purposes. Default is `true`.
- **`timeout`** (`int`): The timeout for the request in seconds. Default is `60`.
- **`timeUnit`** (`TimeUnit`): The unit of time used for the timeout. Default is `TimeUnit.SECONDS`.
- **`formData`** (`FormData?`): Form data for requests like `POST`, `PUT`, etc. Default is `null`.
- **`method`** (`RequestMethod`): The HTTP request method to use, such as `GET`, `POST`, `PUT`, `PATCH`, or `DELETE`.
- **`body`** (`Map<String, dynamic>?`): The body content for `POST`, `PUT`, `PATCH`, and similar methods. Default is `null`.

### Returns

Returns an instance of `ImpakResponse`. This class contains the following properties:
- **`statusCode`** (`int?`): The HTTP status code from the response.
- **`data`** (`dynamic`): The response data from the API. This is dynamic, meaning it can be any type, depending on the API response. You can safely cast or map this data into your desired format.
- **`error`** (`dynamic`): In case of an error, the error details are returned here.

### Example Usage

#### Making a `GET` request:
```dart
Impakdio().call(
  path: 'users/1',
  method: RequestMethod.GET,
  headers: {'Authorization': 'Bearer token'},
  useAuthorization: true,
  timeout: 30,
).then((response) {
  if (response.statusCode == 200) {
    // Handle success
    print('Response Data: ${response.data}');
  } else {
    // Handle error
    print('Error: ${response.error}');
  }
});
```

#### Making a `POST` request with body data:
```dart
Impakdio().call(
  path: 'users',
  method: RequestMethod.POST,
  body: {'name': 'John Doe', 'email': 'john@example.com'},
  headers: {'Authorization': 'Bearer token'},
  timeout: 30,
).then((response) {
  if (response.statusCode == 201) {
    // Handle success
    print('Created User: ${response.data}');
  } else {
    // Handle error
    print('Error: ${response.error}');
  }
});
```

### Error Handling

The `call` method handles various error types and throws specific `ImpakdioException` errors, which can include:
- **`TIMEOUT_ERROR`**: The request timed out.
- **`CANCELLED_ERROR`**: The request was cancelled by the user.
- **`AUTHORIZATION_ERROR`**: Unauthorized request (e.g., invalid or missing authorization token).
- **`BAD_REQUEST`**: The request was not valid (e.g., incorrect input or parameters).
- **`CONNECTION_ERROR`**: Failed to establish a connection to the server.
- **`UNKNOWN_ERROR`**: An unknown error occurred.
- **`SERVER_ERROR`**: The server returned a general error.

Each of these exceptions includes a `statusCode` (if available) and a message describing the error.

### Notes

- The `data` returned by the API is dynamic, which means it can be a simple value (e.g., a number or string), a JSON object, or even an array, depending on the API response.
- It is important to check the `statusCode` and the `data` properly to handle success and failure conditions in a type-safe manner.

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

This project is licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.
# impakdio
