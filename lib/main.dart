import 'package:test_app/injectable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/contacts/presentations/state/bloc/contacts_bloc.dart';
import 'features/contacts/presentations/ui/contacts_screen.dart';

void main() {
  configureDependencies();
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cogniso App',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: BlocProvider(create: (context) => ContactsBloc(), child: const ContactsScreen()),
    );
  }
}
