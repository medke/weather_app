part of weather;

@lazySingleton
class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit({required WeatherRepository repository})
      : _repository = repository,
        super(WeatherInitial());

  final WeatherRepository _repository;
  WeatherForecastModel? _forecastObject;

  WeatherForecastModel? get forecastObject => _forecastObject;

  String cityName = '';

  void onSubmitLocate() async {
    emit(WeatherCubitLoading.fromState(state));

    final result = await _repository.getWeather();
    result.fold(
      onSuccess: (data) {
        emit(WeatherDataLoaded(forecastObject: data));
      },
      onFailure: (failure) {
        emit(
          WeatherDataError(error: failure.error),
        );
      },
    );
  }

  void onSubmitSearch(String cityName) async {
    emit(WeatherSearchLoading.fromState(state));

    final result = await _repository.getWeather(city: cityName);
    result.fold(
      onSuccess: (data) {
        emit(WeatherDataLoaded(forecastObject: data));
      },
      onFailure: (failure) {
        print(">>>> FAILURE");
        emit(
          WeatherDataError.fromState(state, failure.error),
        );
      },
    );
  }
}
