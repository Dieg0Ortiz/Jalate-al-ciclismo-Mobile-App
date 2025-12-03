import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/profile/presentation/bloc/bikes_bloc.dart';
import 'features/profile/presentation/bloc/bikes_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure dependencies
  await configureDependencies();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>()..add(const CheckAuthStatus()),
        ),
        BlocProvider(
          create: (context) => getIt<ThemeBloc>(),
        ),
        BlocProvider(
          create: (context) => BikesBloc()..add(LoadBikes()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'Jalate al ciclismo Mobile App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            routerConfig: AppRouter.router,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('es', 'ES'),
              Locale('en', 'US'),
            ],
          );
        },
      ),
    );
  }
}
