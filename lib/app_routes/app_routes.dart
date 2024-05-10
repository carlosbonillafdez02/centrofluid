import 'package:fl_centro_fluid/models/menu_option.dart';
import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/screens/screens.dart';
import 'package:fl_centro_fluid/widgets/bottom_navigation_bar.dart';

class AppRoutes {
  static const initialRoute = 'navbar';
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
        route: 'menu',
        icon: Icons.abc,
        name: 'Menú',
        screen: const MenuScreen()),
    MenuOption(
      route: 'navbar',
      icon: Icons.app_registration_outlined,
      name: 'BottomNavBar',
      screen: MyBottomNavBar(),
    ),
    /*
    MenuOption(
        route: 'alert',
        icon: Icons.dangerous,
        name: 'Alertas',
        screen: const AlertScreen()),
    MenuOption(
        route: 'card',
        icon: Icons.card_giftcard,
        name: 'Cards',
        screen: const CardScreen()),
    MenuOption(
        route: 'avatar',
        icon: Icons.supervised_user_circle_outlined,
        name: 'Avatar',
        screen: const AvatarScreen()),
    MenuOption(
        route: 'animated',
        icon: Icons.play_circle_outline_outlined,
        name: 'Animated Container',
        screen: const AnimatedScreen()),
    MenuOption(
        route: 'inputs',
        icon: Icons.input_rounded,
        name: 'Forms: Inputs',
        screen: const InputsScreen()),
    MenuOption(
        route: 'slider',
        icon: Icons.slow_motion_video_rounded,
        name: 'Sliders & Checks',
        screen: const SliderScreen()),
        MenuOption(
        route: 'listviewbuilder',
        icon: Icons.build_circle_outlined,
        name: 'InfiniteScroll - Pull to refresh',
        screen: const ListViewBuilderScreen()),
        */
  ];

  static Map<String, Widget Function(BuildContext)> routes = {
    /*
    'listview1': (BuildContext context) => const ListView1Screen(),
    'listview2': (BuildContext context) => const ListView2Screen(),
    'alert': (BuildContext context) => const AlertScreen(),
    'card': (BuildContext context) => const CardScreen(),
    */
    'home': (BuildContext context) => const HomeScreen(),
    'profile': (BuildContext context) => PerfilScreen(),
    'menu': (BuildContext context) => const MenuScreen(),
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
