import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';

class BotonClientesReservados extends StatelessWidget {
  final List<String> clientesReservados; // Lista de IDs de clientes
  final String claseId; // Agregamos el ID de la clase

  BotonClientesReservados(
      {required this.clientesReservados, required this.claseId});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _mostrarClientesReservados(context);
      },
      child: Text(
        'Ver clientes',
        style: TextStyle(fontSize: 17),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
    );
  }

  void _mostrarClientesReservados(BuildContext context) async {
    final usuariosService =
        Provider.of<UsuariosService>(context, listen: false);
    final clasesService = Provider.of<ClasesService>(context, listen: false);

    List<Usuario> usuarios = [];
    for (String id in clientesReservados) {
      Usuario usuario = await usuariosService.getUsuarioById(id);
      usuarios.add(usuario);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clientes Reservados'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final cliente = usuarios[index];
                return ListTile(
                  leading: AvatarUsuario(usuario: cliente),
                  title: Text('${cliente.nombre} ${cliente.apellido}'),
                  subtitle: Text(cliente.email),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      bool success = await clasesService.cancelarReservaClase(
                          claseId, cliente.id!);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Reserva cancelada para ${cliente.nombre} ${cliente.apellido}')),
                        );
                        Navigator.of(context).pop(); // Cierra el diálogo actual
                        _mostrarClientesReservados(
                            context); // Vuelve a abrir el diálogo con la lista actualizada
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Error al cancelar la reserva')),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
