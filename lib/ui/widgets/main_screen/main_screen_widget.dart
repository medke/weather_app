import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weathet_app/di/di.dart';
import 'package:weathet_app/features/weather/weather.dart';
import 'package:weathet_app/utils/constants.dart';
import 'package:weathet_app/utils/helpers.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  @override
  void initState() {
    getIt<WeatherCubit>().onSubmitLocate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<WeatherCubit, WeatherState>(
        listener: (context, state) {
          if (state is WeatherDataError) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is WeatherCubitLoading) {
            return const Center(
              child: SpinKitCubeGrid(color: Colors.blue, size: 80),
            );
          }
          return ViewWidget();
        },
      ),
    );
  }
}

class ViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                SearchWidget(),
                SizedBox(height: 70),
                CityInfoWidget(),
                SizedBox(height: 15),
              ],
            ),
          ),
          // const HeaderWidget(),
        ],
      ),
    );
  }
}

class CityInfoWidget extends StatelessWidget {
  const CityInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is WeatherSearchLoading) {
          return const SpinKitCubeGrid(color: Colors.blue, size: 80);
        }
        final String? url = makeUri(state.forecastObject);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            url != null ? Image.network(url, scale: 1.2) : const SizedBox(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                appText(
                  size: 30,
                  text: '${state.forecastObject?.location?.name}',
                  isBold: FontWeight.bold,
                  color: primaryColor,
                ),
                RotationTransition(
                  turns: AlwaysStoppedAnimation((state.forecastObject?.current?.windDegree ?? 0) / 360),
                  child: const Icon(Icons.north, color: primaryColor),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                appText(
                  size: 70,
                  text: '${state.forecastObject?.current?.tempC?.round()}°',
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _textEditingController.text = '';
    super.initState();
  }

  void _searchWeather() {
    if (_textEditingController.text.length < 3) {
      return;
    }
    getIt<WeatherCubit>().onSubmitSearch(_textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: 'Enter city name',
              ),
              onSubmitted: (_) => _searchWeather(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchWeather,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
