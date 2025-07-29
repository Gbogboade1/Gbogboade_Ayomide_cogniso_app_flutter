import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test_app/features/contacts/data/datasource/api/contacts_api.dart';
import 'package:test_app/features/contacts/data/models/contact_query_dto.dart';
import 'package:test_app/features/contacts/data/models/contact_search_dto.dart';
import 'package:test_app/features/contacts/data/models/get_contact_response.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late ContactsApi api;

  setUp(() {
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
    api = ContactsApi(dio, baseUrl: 'https://example.com');
  });

  group('ContactsApi', () {
    test('getContacts should return GetContactResponse', () async {
      // Arrange
      final mockJson = {
        "contacts": [
          {"id": 1, "firstName": "John"},
        ],
      };

      dioAdapter.onGet('/users', (server) => server.reply(200, mockJson), queryParameters: {'limit': 10, 'skip': 0});

      // Act
      final response = await api.getContacts(const ContactQueryDto());

      // Assert
      expect(response, isA<GetContactResponse>());
    });

    test('searchContacts should return GetContactResponse', () async {
      // Arrange
      final mockJson = {
        "contacts": [
          {"id": 2, "firstName": "Jane"},
        ],
      };

      dioAdapter.onGet(
        '/users/search',
        (server) => server.reply(200, mockJson),
        queryParameters: {"search": "Jane", 'limit': 10, 'skip': 0},
      );

      // Act
      final response = await api.searchContacts(const ContactSearchDto(search: "Jane"));

      // Assert
      expect(response, isA<GetContactResponse>());
    });
  });
}
