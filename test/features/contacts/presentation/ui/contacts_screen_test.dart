import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_app/features/contacts/data/models/get_contact_response.dart';
import 'package:test_app/features/contacts/data/models/user_data.dart';
import 'package:test_app/features/contacts/domain/contacts_service.dart';
import 'package:test_app/features/contacts/presentations/state/bloc/contacts_bloc.dart';
import 'package:test_app/features/contacts/presentations/ui/contacts_screen.dart';

import 'contacts_screen_test.mocks.dart';

class FakeContactsBloc extends MockBloc<ContactsEvent, ContactsState> implements ContactsBloc {}

@GenerateMocks([ContactsService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockContactsService mockService;
  late ContactsBloc bloc;

  final mockUsers = [UserData(firstName: 'John', lastName: 'Doe', email: 'john@example.com', image: '', id: 1)];
  final mockResponse = GetContactResponse(users: mockUsers);

  setUp(() {
    mockService = MockContactsService();
    bloc = ContactsBloc(contactsService: mockService);

    when(mockService.getContacts(skip: anyNamed('skip'))).thenAnswer((_) async => Right(mockResponse));
  });

  group('ContactsBloc', () {
    testWidgets('ContactsScreen shows search bar', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(375, 812);
      await tester.pumpWidget(
        MaterialApp(home: BlocProvider<ContactsBloc>(create: (_) => bloc, child: const ContactsScreen())),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Contacts By Gbogboade'), findsOneWidget);
    });

  });
}
