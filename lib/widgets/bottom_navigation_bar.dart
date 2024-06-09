import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/screens/screens.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/providers/providers.dart';
import 'package:provider/provider.dart';

class MyBottomNavBar extends StatefulWidget {
  final int? index;

  MyBottomNavBar({super.key, this.index});
  @override
  _MyBottomNavBarState createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ReservaScreen(),
    PerfilScreen(),
    AdminScreen(),
  ];
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index ?? 0;
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Usuario usuario =
        Provider.of<ConnectedUserProvider>(context).activeUser;
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          if (usuario.rol == 'entrenador')
            BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: 'Administración',
            ),
        ],
      ),
    );
  }
}
