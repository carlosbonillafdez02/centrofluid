import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MiAppBar(),
      body: Center(
        child: Text('HomeScreen'),
      ),
    );
  }
}
