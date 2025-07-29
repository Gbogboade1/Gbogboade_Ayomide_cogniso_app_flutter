import '../data/models/get_contact_response.dart';
import 'package:dartz/dartz.dart';

abstract class ContactsService {
  Future<Either<String, GetContactResponse>> getContacts({
    int limit = 10,
    int skip = 0,
  });
  Future<Either<String, GetContactResponse>> searchContacts({
    required String searchTerm,
    int limit = 10,
    int skip = 0,
  });
}
