/// Custom exceptions for the chat application
abstract class ChatException implements Exception {
  final String message;
  final String? code;

  ChatException({
    required this.message,
    this.code,
  });

  @override
  String toString() => message;
}

/// Network-related exceptions
class NetworkException extends ChatException {
  NetworkException({
    required super.message,
    super.code,
  });
}

/// Timeout exception when API calls exceed time limit
class TimeoutException extends NetworkException {
  TimeoutException({
    super.message = 'Request timed out',
    super.code,
  });
}

/// Connection exception when no internet is available
class ConnectionException extends NetworkException {
  ConnectionException({
    super.message = 'No internet connection',
    super.code,
  });
}

/// Server error exceptions (5xx errors)
class ServerException extends ChatException {
  final int? statusCode;

  ServerException({
    required super.message,
    this.statusCode,
    super.code,
  });
}

/// Not found exception (404 errors)
class NotFoundException extends ChatException {
  NotFoundException({
    required super.message,
    super.code,
  });
}

/// Validation exception for invalid input
class ValidationException extends ChatException {
  ValidationException({
    required super.message,
    super.code,
  });
}

/// Generic application exception
class AppException extends ChatException {
  AppException({
    required super.message,
    super.code,
  });
}

/// Helper to determine exception type
ChatException createException(dynamic error) {
  if (error is ChatException) {
    return error;
  }

  final errorString = error.toString().toLowerCase();

  if (errorString.contains('timeout')) {
    return TimeoutException();
  }

  if (errorString.contains('connection') || errorString.contains('socket')) {
    return ConnectionException();
  }

  if (errorString.contains('404')) {
    return NotFoundException(message: 'Resource not found');
  }

  if (errorString.contains('5')) {
    return ServerException(message: 'Server error occurred');
  }

  return AppException(message: error.toString());
}
