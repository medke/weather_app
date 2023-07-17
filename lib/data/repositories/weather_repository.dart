import 'package:injectable/injectable.dart';
import 'package:weathet_app/data/models/base/result/result.dart';
import 'package:weathet_app/data/models/weather_forecast_hourly.dart';
import 'package:weathet_app/data/network/weather_api.dart';

@LazySingleton()
class WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  const WeatherRepository({
    required this.remoteDataSource,
  });

  @override
  Future<Result<WeatherForecastModel, Failure>> getWeather({String? city}) async {
    final response = await remoteDataSource.getWeather(city: city);
    return response.fold(
      onSuccess: (response) => SuccessResult(response),
      onFailure: (failure) => FailureResult(failure),
    );
  }
}

@LazySingleton()
class WeatherRemoteDataSource {
  const WeatherRemoteDataSource({
    @Named('WeatherApi') required this.weatherApi,
  });

  final WeatherApi weatherApi;

  Future<Result<WeatherForecastModel, Failure>> getWeather({String? city}) async {
    try {
      final response = await weatherApi.fetchWeatherForecast(cityName: city);
      if (response.current == null) {
        throw Exception('City not found');
      }
      return SuccessResult(response);
    } catch (e) {
      return FailureResult(UnexpectedFailure(e.toString()));
    }
  }
}
