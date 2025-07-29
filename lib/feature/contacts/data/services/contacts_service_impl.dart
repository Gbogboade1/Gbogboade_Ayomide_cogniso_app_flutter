import 'package:injectable/injectable.dart';

import '../../../../core/domain/entities/api_error.dart';
import '../datasource/contact_datasource.dart';

import '../models/contact_query_dto.dart';
import '../models/contact_search_dto.dart';
import '../models/get_contact_response.dart';

import 'package:dartz/dartz.dart';

import '../../domain/contacts_service.dart';

@LazySingleton(as: ContactsService)
class ContactsServiceImpl extends ContactsService {
  final ContactDatasource _datasource;

  ContactsServiceImpl({required ContactDatasource datasource})
    : _datasource = datasource;

  @override
  Future<Either<String, GetContactResponse>> getContacts({
    int limit = 10,
    int skip = 0,
  }) async {
    try {
      final result = await _datasource.getContacts(
        queryParams: ContactQueryDto(limit: limit, skip: skip),
      );
      return Right(result);
    } on ApiError catch (e) {
      return Left(e.message);
    } 
  }

  @override
  Future<Either<String, GetContactResponse>> searchContacts({
    required String searchTerm,
    int limit = 10,
    int skip = 0,
  }) async {
    try {
      final result = await _datasource.searchContacts(
        queryParams: ContactSearchDto(
          search: searchTerm,
          limit: limit,
          skip: skip,
        ),
      );
      return Right(result);
    } on ApiError catch (e) {
      return Left(e.message);
    }
  }
}
