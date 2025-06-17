import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injectable.config.dart';

final getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: true)
Future<GetIt> configureDependencies() async {
  return getIt.init();
}

@module
abstract class InjectableModule {
  @Named('apiUrl')
  String get apiUrl => 'https://dummyjson.com';
}
