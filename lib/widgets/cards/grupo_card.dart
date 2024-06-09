import 'package:fl_centro_fluid/theme/app_theme.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:provider/provider.dart';

class GrupoCard extends StatelessWidget {
  final Grupo grupo;
  final VoidCallback onTap;
  final bool isSelected;

  const GrupoCard({
    Key? key,
    required this.grupo,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuariosService = Provider.of<UsuariosService>(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isSelected
              ? BorderSide(color: AppTheme.primary, width: 4)
              : BorderSide.none,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                grupo.nombre,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ExpansionTile(
                title: Text('Clientes (${grupo.listaClientes.length})'),
                children: [
                  ...grupo.listaClientes.map((userId) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: FutureBuilder<Usuario>(
                        future: usuariosService.getUsuarioById(userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            final usuario = snapshot.data;
                            if (usuario == null) {
                              return Text('Usuario no encontrado');
                            }
                            return UsuarioCard(usuario: usuario);
                          } else {
                            // Muestra un indicador de carga mientras se obtiene el usuario
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.primary,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
