import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/providers/providers.dart';
import 'package:fl_centro_fluid/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:fl_centro_fluid/app_routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Necesario para inicializar SharedPreferences
  await initializeDateFormatting(
      'es_ES', null); // Inicializa el formato de fecha
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(AppState(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  MyApp({required this.prefs});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(prefs: prefs),
        child:
            Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Centro Fluid',
            theme: themeProvider.isDarkMode
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            initialRoute: AppRoutes.initialRoute,
            onGenerateRoute: AppRoutes.onGenerateRoute,
          );
        }));
  }
}

class AppState extends StatelessWidget {
  final SharedPreferences prefs;

  AppState({required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => EjerciciosService()),
        ChangeNotifierProvider(create: (context) => SesionesService()),
        ChangeNotifierProvider(create: (context) => ClasesService()),
        ChangeNotifierProvider(create: (context) => UsuariosService()),
        ChangeNotifierProvider(create: (context) => GruposService()),
        ChangeNotifierProvider(
            create: (context) => ConnectedUserProvider(prefs: prefs))
      ],
      child: MyApp(prefs: prefs),
    );
  }
}
