import 'package:dartz/dartz.dart';

import '../entities/api_error.dart';
import '../entities/http_error.dart';
import '../exceptions/api_failure.dart';
import 'api_service_handler.dart';

mixin ApiServiceHandlerMixin on ApiServiceHandler {
  Future<Either<ApiFailure, E>> execute<E>(
    Future<E> Function() supplier,
  ) async {
    try {
      return Right(await supplier.call());
    } on ApiError catch (e, stackTrace) {
      logger.severe('Failed to get post from API', e, stackTrace);
      return Left(ApiFailure.from(e));
    } on HttpError catch (e, stackTrace) {
      logger.severe('Failed to get post from API', e, stackTrace);
      return Left(ApiFailure.from(e.toApiError()));
    } on Exception catch (e, stackTrace) {
      logger.severe('Failed to get post from API', e, stackTrace);
      return const Left(ApiFailure.unknown());
    }
  }
}
