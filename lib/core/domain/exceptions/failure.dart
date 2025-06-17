import '../../data/models/failure.dart';
import 'error_code.dart';

class ServerFailure implements Failure<ErrorCode> {
  const ServerFailure();

  @override
  ErrorCode get errorCode => ErrorCode.serverError;
}

class NotFoundFailure implements Failure<ErrorCode> {
  const NotFoundFailure([this.entity]);

  final Object? entity;

  @override
  ErrorCode get errorCode => ErrorCode.entityNotFound;
}

class ErrorCodeFailure implements Failure<ErrorCode> {
  const ErrorCodeFailure(this.errorCode);

  @override
  final ErrorCode errorCode;
}
