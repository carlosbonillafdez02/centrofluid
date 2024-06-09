import 'package:fl_centro_fluid/models/menu_option.dart';
import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/screens/screens.dart';
import 'package:fl_centro_fluid/widgets/bottom_navigation_bar.dart';

class AppRoutes {
  static const initialRoute = 'login';

  static final menuOptions = <MenuOption>[
    MenuOption(
        route: 'home',
        icon: Icons.home_max_sharp,
        name: 'Home Screen',
        screen: const HomeScreen()),
    MenuOption(
      route: 'registro',
      icon: Icons.app_registration_outlined,
      name: 'Registro',
      screen: const RegisterScreen(),
    ),
    MenuOption(
      route: 'login',
      icon: Icons.login,
      name: 'Login',
      screen: const LoginScreen(),
    ),
    MenuOption(
        route: 'profile',
        icon: Icons.person,
        name: 'Perfil',
        screen: PerfilScreen()),
    MenuOption(
        route: 'Admin',
        icon: Icons.admin_panel_settings,
        name: 'Admin',
        screen: AdminScreen()),
    MenuOption(
      route: 'navbar',
      icon: Icons.app_registration_outlined,
      name: 'BottomNavBar',
      screen: MyBottomNavBar(),
    ),
  ];

  static Map<String, Widget Function(BuildContext)> routes = {
    'home': (BuildContext context) => const HomeScreen(),
    'profile': (BuildContext context) => PerfilScreen(),
    'menu': (BuildContext context) => AdminScreen(),
  };

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    for (final option in menuOptions) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }

    return appRoutes;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Function? pageContentBuilder =
        AppRoutes.getAppRoutes()[settings.name];

    if (pageContentBuilder != null) {
      if (settings.arguments != null) {
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => pageContentBuilder(context, args),
        );
      } else {
        return MaterialPageRoute(
          builder: (context) => pageContentBuilder(context),
        );
      }
    }

    // Si la ruta solicitada es desconocida y no es la ruta de inicio, redirigir a la pantalla de inicio.
    if (settings.name != initialRoute) {
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    }

    // Si la ruta solicitada es la ruta de inicio, redirigir a la pantalla de inicio de sesión.
    return MaterialPageRoute(builder: (context) => const LoginScreen());
  }
}
