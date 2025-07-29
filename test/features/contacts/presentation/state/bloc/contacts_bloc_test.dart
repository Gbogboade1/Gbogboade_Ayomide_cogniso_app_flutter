import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:test_app/features/contacts/domain/contacts_service.dart';
import 'package:test_app/features/contacts/data/models/get_contact_response.dart';
import 'package:test_app/features/contacts/data/models/user_data.dart';
import 'package:test_app/features/contacts/presentations/state/bloc/contacts_bloc.dart';
import 'contacts_bloc_test.mocks.dart';

@GenerateMocks([ContactsService])
void main() {
  late MockContactsService mockService;

  setUp(() {
    mockService = MockContactsService();
  });

  group('ContactsBloc', () {
    final mockUsers = [UserData(firstName: 'John', lastName: 'Doe', email: 'john@example.com', image: '', id: 1)];
    final mockResponse = GetContactResponse(users: mockUsers);

    blocTest<ContactsBloc, ContactsState>(
      'emits [ContactsLoading, ContactsLoaded] when LoadContactsPage succeeds',
      build: () {
        when(mockService.getContacts(skip: anyNamed('skip'))).thenAnswer((_) async => Right(mockResponse));
        return ContactsBloc(contactsService: mockService);
      },
      act: (bloc) => bloc.add(const ContactsEvent.loadContactsPage(1)),
      expect: () => [isA<ContactsLoading>(), isA<ContactsLoaded>()],
      verify: (_) {
        verify(mockService.getContacts(skip: anyNamed('skip'))).called(1);
      },
    );

    blocTest<ContactsBloc, ContactsState>(
      'emits [ContactsLoading, ContactsLoadingFailed] when LoadContactsPage fails',
      build: () {
        when(mockService.getContacts(skip: anyNamed('skip'))).thenAnswer((_) async => const Left('Failed'));
        return ContactsBloc(contactsService: mockService);
      },
      act: (bloc) => bloc.add(const ContactsEvent.loadContactsPage(1)),
      expect: () => [isA<ContactsLoading>(), isA<ContactsLoadingFailed>()],
    );

    blocTest<ContactsBloc, ContactsState>(
      'emits [ContactsLoading, ContactsSearchFound] when SearchContacts succeeds',
      build: () {
        when(mockService.getContacts(skip: anyNamed('skip'))).thenAnswer((_) async => Right(mockResponse));
        return ContactsBloc(contactsService: mockService);
      },
      act: (bloc) => bloc.add(const ContactsEvent.searchContacts('John')),
      expect: () => [isA<ContactsLoading>(), isA<ContactsSearchFound>()],
      verify: (_) {
        verify(mockService.getContacts(skip: anyNamed('skip'))).called(1);
      },
    );

    blocTest<ContactsBloc, ContactsState>(
      'emits [ContactsLoading, ContactsSearchFailed] when SearchContacts fails',
      build: () {
        when(mockService.getContacts(skip: anyNamed('skip'))).thenAnswer((_) async => const Left('Search failed'));
        return ContactsBloc(contactsService: mockService);
      },
      act: (bloc) => bloc.add(const ContactsEvent.searchContacts('Jane')),
      expect: () => [isA<ContactsLoading>(), isA<ContactsSearchFailed>()],
    );
  });
}
