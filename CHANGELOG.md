# Changelog

## [0.0.1] - 2025-01-23
### Initial release
- **Impakdio** class added with core functionality for HTTP requests.
    - Allows making API calls with GET, POST, PUT, PATCH, and DELETE methods.
    - Support for setting a **base URL** and **authentication tokens**.
    - **Type-safe** API responses with custom deserialization for any type of response data.
    - **Custom error handling** with specific exceptions and status codes.
    - Support for **request cancellation** via `CancelToken`.
    - **Request timeout handling** with customizable timeout duration.
    - Includes optional logging for request details.
    - Supports handling of **authorization** headers with or without tokens.

### Features:
- **Base URL configuration**: You can now configure the base URL globally for all requests using `initBaseUrl()`.
- **Authentication token support**: Set a global authentication token via `setAuthenticationToken()`.
- **Customizable request parameters**: Customize headers, query parameters, form data, and body for requests.
- **Type-safe response handling**: Automatically deserializes successful responses into custom types using `typeSafeCall()`.
- **Error handling**: Includes comprehensive error handling for different response codes and timeouts.
- **Support for logging**: Option to log request details for debugging purposes.
- **Multiple HTTP methods**: GET, POST, PUT, PATCH, DELETE, and more, depending on the request type.
- **Cancellation support**: Use `CancelToken` to cancel ongoing requests.
