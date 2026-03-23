import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/repository/favorites_repository.dart';
import 'package:weather_app/services/app_preferences.dart';
import 'package:weather_app/theme/theme_cubit.dart';
import 'package:weather_app/theme/theme_state.dart';

import 'cubit/favorites_cubit.dart';
import 'cubit/weather_cubit.dart';
import 'firebase_options.dart';
import 'models/weather_data.dart';
import 'repository/weather_repository.dart';
import 'screens/weather_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  final prefs = await SharedPreferences.getInstance();
  final appPreferences = AppPreferences(prefs);
  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();

  Hive.registerAdapter(WeatherDataAdapter());

  await Hive.openBox<WeatherData>('weatherBox');

  runApp(MyApp(appPreferences: appPreferences));
}

class MyApp extends StatelessWidget {
  final AppPreferences appPreferences;

  const MyApp({super.key, required this.appPreferences});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(appPreferences)..loadTheme(),
        ),
        BlocProvider<WeatherCubit>(
          create: (_) => WeatherCubit(
            repository: WeatherRepository(),
            preferences: appPreferences,
          )..loadLastCity(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (_) => FavoritesCubit(FavoritesRepository()),
        ),
      ],

      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: const WeatherScreen(),
          );
        },
      ),
    );
  }
}
