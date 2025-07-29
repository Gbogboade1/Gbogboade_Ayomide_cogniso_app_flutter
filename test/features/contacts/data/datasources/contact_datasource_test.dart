import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_app/features/contacts/data/datasource/api/contacts_api.dart';
import 'package:test_app/features/contacts/data/datasource/contact_datasource.dart';
import 'package:test_app/features/contacts/data/models/contact_query_dto.dart';
import 'package:test_app/features/contacts/data/models/contact_search_dto.dart';
import 'package:test_app/features/contacts/data/models/get_contact_response.dart';


import 'contact_datasource_test.mocks.dart';

@GenerateMocks([ContactsApi])
void main() {
  late ContactDatasource datasource;
  late MockContactsApi mockContactsApi;

  setUp(() {
    mockContactsApi = MockContactsApi();
    datasource = ContactDatasource(mockContactsApi);
  });

  group('ContactDatasource', () {
    test('getContacts should return GetContactResponse from ContactsApi', () async {
      // Arrange
      final mockResponse = GetContactResponse(); // Create a dummy response
      const queryDto = ContactQueryDto();
      when(mockContactsApi.getContacts(queryDto)).thenAnswer((_) async => mockResponse);

      // Act
      final result = await datasource.getContacts(queryParams: queryDto);

      // Assert
      expect(result, mockResponse);
      verify(mockContactsApi.getContacts(queryDto)).called(1);
    });

    test('searchContacts should return GetContactResponse from ContactsApi', () async {
      // Arrange
      final mockResponse = GetContactResponse();
      const queryDto = ContactSearchDto();
      when(mockContactsApi.searchContacts(queryDto)).thenAnswer((_) async => mockResponse);

      // Act
      final result = await datasource.searchContacts(queryParams: queryDto);

      // Assert
      expect(result, mockResponse);
      verify(mockContactsApi.searchContacts(queryDto)).called(1);
    });
  });
}
