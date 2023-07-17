import 'dart:io' as http;

import 'package:injectable/injectable.dart';

@module
abstract class HttpClientModule {
  @lazySingleton
  http.HttpClient get httpClient => http.HttpClient();
}
