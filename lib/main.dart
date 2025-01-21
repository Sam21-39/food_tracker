import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:food_tracker/core/blocs/auth/auth_cubit.dart';
import 'package:food_tracker/core/blocs/food_entry/food_entry_cubit.dart';
import 'package:food_tracker/core/blocs/localization/localization_cubit.dart';
import 'package:food_tracker/core/blocs/navigation/navigation_cubit.dart';
import 'package:food_tracker/core/blocs/sync/sync_cubit.dart';
import 'package:food_tracker/core/blocs/theme/theme_cubit.dart';
import 'package:food_tracker/core/config/objectbox.dart';
import 'package:food_tracker/core/config/supabase_config.dart';
import 'package:food_tracker/core/theme/app_theme.dart';
import 'package:food_tracker/features/home/screens/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Initialize ObjectBox
  final objectBox = await ObjectBox.create();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(
    objectBox: objectBox,
    prefs: prefs,
  ));
}

class MyApp extends StatelessWidget {
  final ObjectBox objectBox;
  final SharedPreferences prefs;

  const MyApp({
    super.key,
    required this.objectBox,
    required this.prefs,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(prefs),
        ),
        BlocProvider(
          create: (context) => LocalizationCubit(prefs),
        ),
        BlocProvider(
          create: (context) => AuthCubit(SupabaseConfig.client),
        ),
        BlocProvider(
          create: (context) => SyncCubit(
            SupabaseConfig.client,
            objectBox,
            prefs,
          ),
        ),
        BlocProvider(
          create: (context) => FoodEntryCubit(
            objectBox,
            context.read<SyncCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
      ],
      child: const FoodTrackerApp(),
    );
  }
}

class FoodTrackerApp extends StatelessWidget {
  const FoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        return BlocBuilder<LocalizationCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp(
              title: 'Food Tracker',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              locale: locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales:
                  context.read<LocalizationCubit>().supportedLocales,
              home: const HomeScreen(),
            );
          },
        );
      },
    );
  }
}
