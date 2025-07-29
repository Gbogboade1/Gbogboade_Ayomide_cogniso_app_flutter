import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:test_app/core/domain/entities/api_error.dart';

import 'package:test_app/features/contacts/data/datasource/contact_datasource.dart';
import 'package:test_app/features/contacts/data/models/get_contact_response.dart';
import 'package:test_app/features/contacts/data/services/contacts_service_impl.dart';

import 'contacts_service_impl_test.mocks.dart';

@GenerateMocks([ContactDatasource])
void main() {
  late ContactsServiceImpl service;
  late MockContactDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockContactDatasource();
    service = ContactsServiceImpl(datasource: mockDatasource);
  });

  group('ContactsServiceImpl', () {
    test('getContacts returns Right(GetContactResponse) when datasource succeeds', () async {
      // Arrange
      final mockResponse = GetContactResponse(); // Adjust constructor as needed
      when(mockDatasource.getContacts(queryParams: anyNamed('queryParams'))).thenAnswer((_) async => mockResponse);

      // Act
      final result = await service.getContacts(limit: 5, skip: 1);

      // Assert
      expect(result, isA<Right<String, GetContactResponse>>());
      expect(result.getOrElse(() => GetContactResponse()), mockResponse);
    });

    test('getContacts returns Left(error message) when datasource throws ApiError', () async {
      // Arrange
      when(
        mockDatasource.getContacts(queryParams: anyNamed('queryParams')),
      ).thenThrow(const ApiError(message: 'Some error', status: 404));

      // Act
      final result = await service.getContacts();

      // Assert
      expect(result, isA<Left<String, GetContactResponse>>());
      expect(result.swap().getOrElse(() => ''), equals('Some error'));
    });

    test('searchContacts returns Right(GetContactResponse) when datasource succeeds', () async {
      // Arrange
      final mockResponse = GetContactResponse();
      when(mockDatasource.searchContacts(queryParams: anyNamed('queryParams'))).thenAnswer((_) async => mockResponse);

      // Act
      final result = await service.searchContacts(searchTerm: 'John');

      // Assert
      expect(result, isA<Right<String, GetContactResponse>>());
      expect(result.getOrElse(() => GetContactResponse()), mockResponse);
    });

    test('searchContacts returns Left(error message) when datasource throws ApiError', () async {
      // Arrange
      when(
        mockDatasource.searchContacts(queryParams: anyNamed('queryParams')),
      ).thenThrow(const ApiError(message: 'Search error', status: 404));

      // Act
      final result = await service.searchContacts(searchTerm: 'Jane');

      // Assert
      expect(result, isA<Left<String, GetContactResponse>>());
      expect(result.swap().getOrElse(() => ''), equals('Search error'));
    });
  });
}
