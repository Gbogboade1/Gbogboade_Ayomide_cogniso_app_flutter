import 'package:injectable/injectable.dart';

import '../models/contact_query_dto.dart';
import '../models/contact_search_dto.dart';
import '../models/get_contact_response.dart';
import 'api/contacts_api.dart';

import '../../../../core/data/datasources/apis/api_error_handler_mixin.dart';

@lazySingleton
class ContactDatasource with ApiErrorHandlerMixin {
  final ContactsApi _contactsApi;

  ContactDatasource(ContactsApi contactsApi) : _contactsApi = contactsApi;

  Future<GetContactResponse> getContacts({
    ContactQueryDto queryParams = const ContactQueryDto(),
  }) async => executeRaw(() => _contactsApi.getContacts(queryParams));
  Future<GetContactResponse> searchContacts({
    ContactSearchDto queryParams = const ContactSearchDto(),
  }) async => executeRaw(() => _contactsApi.searchContacts(queryParams));
}
