import '../../data/models/failure.dart';
import '../entities/api_error.dart';

sealed class ApiFailure implements Failure<int> {
  const ApiFailure(int statusCode, {this.apiError}) : errorCode = statusCode;

  factory ApiFailure.from(ApiError apiError) {
    switch (apiError.status) {
      case 401:
        return UnauthorizedFailure(apiError);
      case 403:
        return ForbiddenFailure(apiError);
      case 404:
        return NotFoundFailure(apiError);
      case 400:
        return BadRequestFailure(apiError);
      case 500:
        return ServerFailure(apiError);
      default:
        return const UnknownFailure();
    }
  }

  const factory ApiFailure.unknown([ApiError? apiError]) = UnknownFailure;
  const factory ApiFailure.server(ApiError apiError) = ServerFailure;
  const factory ApiFailure.notFound(ApiError apiError) = NotFoundFailure;
  const factory ApiFailure.badRequest(ApiError apiError) = BadRequestFailure;
  const factory ApiFailure.forbidden(ApiError apiError) = ForbiddenFailure;
  const factory ApiFailure.unauthorized(ApiError apiError) =
      UnauthorizedFailure;

  static const int unknownError = -1;

  @override
  final int errorCode;
  final ApiError? apiError;

  bool get isUnauthorized => errorCode == 401;
  bool get isForbidden => errorCode == 403;
  bool get isNotFound => errorCode == 404;
  bool get isBadRequest => errorCode == 400;
  bool get isServerError => errorCode == 500;
  bool get isUnknown => errorCode == unknownError;

  @override
  String toString() => 'ApiFailure(errorCode: $errorCode, apiError: $apiError)';
}

class UnauthorizedFailure extends ApiFailure {
  const UnauthorizedFailure(ApiError apiError) : super(401, apiError: apiError);
}

class ForbiddenFailure extends ApiFailure {
  const ForbiddenFailure(ApiError apiError) : super(403, apiError: apiError);
}

class NotFoundFailure extends ApiFailure {
  const NotFoundFailure(ApiError apiError) : super(404, apiError: apiError);
}

class BadRequestFailure extends ApiFailure {
  const BadRequestFailure(ApiError apiError) : super(400, apiError: apiError);
}

class ServerFailure extends ApiFailure {
  const ServerFailure(ApiError apiError) : super(500, apiError: apiError);
}

class UnknownFailure extends ApiFailure {
  const UnknownFailure([ApiError? apiError])
    : super(ApiFailure.unknownError, apiError: apiError);
}
