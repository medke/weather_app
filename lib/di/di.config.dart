// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:io' as _i3;

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:weathet_app/data/network/weather_api.dart' as _i4;
import 'package:weathet_app/data/repositories/weather_repository.dart' as _i5;
import 'package:weathet_app/di/di_module.dart' as _i7;
import 'package:weathet_app/features/weather/weather.dart' as _i6;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final httpClientModule = _$HttpClientModule();
    gh.lazySingleton<_i3.HttpClient>(() => httpClientModule.httpClient);
    gh.factory<_i4.WeatherApi>(
      () => _i4.WeatherApi(client: gh<_i3.HttpClient>()),
      instanceName: 'WeatherApi',
    );
    gh.lazySingleton<_i5.WeatherRemoteDataSource>(() =>
        _i5.WeatherRemoteDataSource(
            weatherApi: gh<_i4.WeatherApi>(instanceName: 'WeatherApi')));
    gh.lazySingleton<_i5.WeatherRepository>(() => _i5.WeatherRepository(
        remoteDataSource: gh<_i5.WeatherRemoteDataSource>()));
    gh.lazySingleton<_i6.WeatherCubit>(
        () => _i6.WeatherCubit(repository: gh<_i5.WeatherRepository>()));
    return this;
  }
}

class _$HttpClientModule extends _i7.HttpClientModule {}
