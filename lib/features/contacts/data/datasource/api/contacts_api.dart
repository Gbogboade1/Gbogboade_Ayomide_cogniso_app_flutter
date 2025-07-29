import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/contact_query_dto.dart';
import '../../models/contact_search_dto.dart';
import '../../models/get_contact_response.dart';

part 'contacts_api.g.dart';

@RestApi()
@lazySingleton
abstract class ContactsApi {
  @factoryMethod
  factory ContactsApi(Dio dio, {@Named('apiUrl') String? baseUrl}) =>
      _ContactsApi._(dio, baseUrl: baseUrl);

  ContactsApi._();

  @GET('/users')
  Future<GetContactResponse> getContacts(
    @Queries() ContactQueryDto queryParams,
  );

  @GET('/users/search')
  Future<GetContactResponse> searchContacts(
    @Queries() ContactSearchDto queryParams,
  );
}
