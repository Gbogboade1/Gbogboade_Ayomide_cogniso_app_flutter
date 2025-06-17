import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart' hide Environment;
import 'package:logging/logging.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../datasources/http_client_adapter_provider_web.dart'
    if (dart.library.io) '../datasources/http_client_adapter_provider_io.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio() =>
      Dio(BaseOptions(contentType: Headers.jsonContentType))
        ..httpClientAdapter = HttpClientAdapterProvider().create()
        ..interceptors.addAll([
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            logPrint: _logger.fine,
            enabled: true,
          ),
        ]);

  static final Logger _logger = Logger('DioModule');
}
