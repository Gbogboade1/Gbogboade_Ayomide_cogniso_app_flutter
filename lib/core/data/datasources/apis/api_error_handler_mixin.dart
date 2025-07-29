import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';

import '../../../domain/entities/api_error.dart';
import '../../../domain/entities/http_error.dart';
import '../../models/response.dart' as api;

mixin ApiErrorHandlerMixin {
  Future<E> execute<E>(Future<api.Response<E>> Function() supplier) async {
    try {
      final response = await supplier.call();

      if (response.data != null) {
        return response.data!;
      } else {
        throw ApiError(status: response.status, message: response.message!, params: response.params);
      }
    } on DioException catch (err, stackTrace) {
      throw handleDioException(err, stackTrace);
    }
  }

  Future<E> executeRaw<E>(Future<E> Function() supplier) async {
    try {
      return await supplier.call();
    } on DioException catch (err, stackTrace) {
      throw handleDioException(err, stackTrace);
    }
  }

  ApiError handleDioException(DioException err, StackTrace stackTrace) {
    final response = err.response;
    if (_isApiErrorResponse(response)) {
      return ApiError.fromJson(response!.data! as Map<String, dynamic>);
    } else if (_isHttpErrorResponse(response)) {
      throw HttpError(
        error:
            (response!.data is String ? jsonDecode(response.data!.toString())['error'] : response.data.error)
                .toString(),
        status: response.statusCode!,
        description: err.message ?? '',
      );
    }
    if (response?.data.toString().contains('Server Error') ?? false) {
      throw const ApiError(status: 500, message: 'Could not reach server, try again later');
    }
    if (err.error is NSErrorClientException) {
      throw const ApiError(status: 500, message: "The Internet connection appears to be offline.");
    }

    throw ApiError(message: 'API invalid response ${err.error}: ${response?.data ?? response}', status: 500);
  }

  bool _isApiErrorResponse(Response<dynamic>? response) {
    if (response?.data is! Map<String, dynamic>) {
      return false;
    }

    final error = (response?.data ?? <String, dynamic>{}) as Map<String, dynamic>;

    return error.containsKey('status') && error.containsKey('message') && error.containsKey('code');
  }

  bool _isHttpErrorResponse(Response<dynamic>? response) {
    try {
      final data = response?.toString();
      if (data == null) {
        return false;
      }
      final error = jsonDecode(data) as Map<String, dynamic>;

      return error.containsKey('error') && (response?.statusCode ?? 0) >= 400;
    } catch (e) {
      return false;
    }
  }
}
