import '../../data/models/failure.dart';

sealed class ErrorContext implements Failure<ErrorContext> {
  const ErrorContext({required this.message, this.error, this.stackTrace});

  const factory ErrorContext.unknown({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = UnknownErrorContextFailure;

  const factory ErrorContext.invalidToken() = InvalidUserTokenFailure;

  const factory ErrorContext.network() = NetworkErrorContextFailure;

  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  @override
  ErrorContext get errorCode => this;

  @override
  String toString() {
    return 'ErrorContext{message: $message, error: $error, stackTrace: $stackTrace}';
  }
}

class UnknownErrorContextFailure extends ErrorContext {
  const UnknownErrorContextFailure({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

class InvalidUserTokenFailure extends ErrorContext {
  const InvalidUserTokenFailure({
    super.message = 'Token is invalid or does not exist',
  });
}

class NetworkErrorContextFailure extends ErrorContext {
  const NetworkErrorContextFailure({super.message = 'No internet connection'});
}
