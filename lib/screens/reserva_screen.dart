import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';

class ReservaScreen extends StatelessWidget {
   
  const ReservaScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MiAppBar(),
      body: Column(
         children: [
          ClasesCalendario(),
         ] 
      ),
    );
  }
}