import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weathet_app/data/models/weather_forecast_hourly.dart';
import 'package:weathet_app/data/repositories/weather_repository.dart';
import 'package:weathet_app/di/di.dart';
import 'package:weathet_app/features/weather/weather.dart';
import 'package:weathet_app/ui/widgets/app/my_app.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockWeatherForecastModel extends Mock implements WeatherForecastModel {}

class MockWeatherCubit extends MockCubit<WeatherState> implements WeatherCubit {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('MainScreenWidget Integration Test', () {
    late WeatherRepository weatherRepository;
    late MockWeatherCubit weatherCubit;
    late MockWeatherForecastModel weatherForecastModel;
    // Mock the WeatherForecastModel object

    setUpAll(() {
      weatherRepository = MockWeatherRepository();
      weatherCubit = MockWeatherCubit();
      weatherForecastModel = MockWeatherForecastModel();

      getIt.registerLazySingleton<WeatherCubit>(() => weatherCubit);
      getIt.registerLazySingleton<WeatherRepository>(() => weatherRepository);
    });

    testWidgets('MainScreenWidget shows loading spinner when WeatherCubitLoading state is emitted',
        (WidgetTester tester) async {
      // Stub the WeatherCubit state to emit WeatherCubitLoading
      when(() => weatherCubit.state).thenAnswer((invocation) => const WeatherCubitLoading());

      await tester.pumpWidget(const MyApp());

      // Verify that the loading spinner is displayed
      expect(find.byType(SpinKitCubeGrid), findsOneWidget);
    });
    //
    // testWidgets('MainScreenWidget shows CityInfoWidget when WeatherDataLoaded state is emitted',
    //     (WidgetTester tester) async {
    //   // Stub the WeatherCubit state to emit WeatherDataLoaded
    //   final mockWeatherForecastModel = WeatherForecastModel(); // Mock the WeatherForecastModel object
    //   when(() => weatherCubit.state).thenAnswer((invocation) => const WeatherDataLoaded());
    //
    //   await tester.pumpWidget(
    //     const MyApp(),
    //   );
    //
    //   // Verify that the CityInfoWidget is displayed
    //   expect(find.byType(CityInfoWidget), findsOneWidget);
    // });

    testWidgets('SearchWidget triggers weather search when search button is pressed', (WidgetTester tester) async {
      // Stub the WeatherCubit state to emit WeatherSearchLoading

      when(()=>weatherForecastModel.current).thenReturn(Current(tempC: 30));
      when(()=>weatherForecastModel.location).thenReturn(Location(name: 'Paris'));

      when(() => weatherCubit.state)
          .thenAnswer((invocation) => WeatherDataLoaded(forecastObject: weatherForecastModel));

      await tester.pumpWidget(const MyApp());

      // Enter a city name in the TextField
      await tester.enterText(find.byType(TextField), 'London');
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      // Verify that the searchWeather function is called
      verify(() => weatherCubit.onSubmitSearch('London')).called(1);
    });
  });
}
