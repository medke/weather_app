import 'dart:convert';
import 'dart:developer';
import 'dart:io' as http;

import 'package:injectable/injectable.dart';
import 'package:weathet_app/data/models/weather_forecast_hourly.dart';
import 'package:weathet_app/utils/constants.dart';
import 'package:weathet_app/utils/location.dart';

@Named('WeatherApi')
@injectable
class WeatherApi {
  const WeatherApi({
    required this.client,
  });

  final http.HttpClient client;

  static const _host = Constants.WEATHER_BASE_SCHEME + Constants.WEATHER_BASE_URL_DOMAIN;

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  Future<WeatherForecastModel> fetchWeatherForecast({String? cityName}) async {
    Map<String, String> parameters = {};

    if (cityName != null && cityName.isNotEmpty) {
      parameters = {
        'key': Constants.WEATHER_APP_ID,
        'q': cityName,
        'days': '1',
      };
    } else {
      UserLocation location = UserLocation();
      await location.determinePosition().then((position) {
        final String fullLocation = '${position.latitude},${position.longitude}';
        print(">>>>> fulllocation : $fullLocation");
        parameters = {
          'key': Constants.WEATHER_APP_ID,
          'q': fullLocation,
          'days': '1',
        };
      });
    }

    final url = _makeUri(Constants.WEATHER_FORECAST_PATH, parameters);

    log('request: ${url.toString()}');
    final request = await client.getUrl(url);
    final response = await request.close();
    final json = await response
        .transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((val) => jsonDecode(val)) as Map<String, dynamic>;
    return WeatherForecastModel.fromJson(json);
  }
}
