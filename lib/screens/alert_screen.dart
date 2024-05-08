import 'package:flutter/material.dart';

class AlertScreen extends StatelessWidget {
  const AlertScreen({Key? key}) : super(key: key);

  void displayDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Alerta"),
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Este es el contenido de la alerta"),
                SizedBox(height: 10,),
                FlutterLogo(size:100)
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () => displayDialog(context),
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "Mostrar alerta",
            style: TextStyle(fontSize: 20),
          ),
        ),
      )),
    );
  }
}
