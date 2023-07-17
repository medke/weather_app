import 'package:weathet_app/data/models/weather_forecast_hourly.dart';

String? makeUri(WeatherForecastModel? model) {
  return model?.current!.condition?.icon != null
      ? 'https://${((model?.current!.condition?.icon).toString().substring(2)).replaceAll("64", "128")}'
      : null;
}
