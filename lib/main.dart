import 'package:fl_centro_fluid/screens/reserva_screen.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/providers/providers.dart';
import 'package:fl_centro_fluid/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:fl_centro_fluid/app_routes/app_routes.dart';

void main() {
  initializeDateFormatting('es_ES', null).then((_) {
    runApp(AppState());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
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
            //home: ReservaScreen(),
          );
        }));
  }
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => EjerciciosService()),
        ChangeNotifierProvider(create: (context) => SesionesService()),
        ChangeNotifierProvider(create: (context) => ClasesService()),
        ChangeNotifierProvider(create: (context) => UsuariosService()),
        ChangeNotifierProvider(create: (context) => ConnectedUserProvider())
      ],
      child: MyApp(),
    );
  }
}
