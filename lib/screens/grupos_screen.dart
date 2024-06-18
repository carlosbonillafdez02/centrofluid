import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_centro_fluid/screens/screens.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';
import 'package:fl_centro_fluid/models/models.dart';

class GruposScreen extends StatefulWidget {
  const GruposScreen({Key? key}) : super(key: key);

  @override
  _GruposScreenState createState() => _GruposScreenState();
}

class _GruposScreenState extends State<GruposScreen> {
  Grupo? _selectedGrupo;

  @override
  Widget build(BuildContext context) {
    final gruposService = Provider.of<GruposService>(context);

    if (gruposService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión Grupos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CrearGrupo()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              if (_selectedGrupo != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ModificarGrupo(grupo: _selectedGrupo!)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Selecciona un grupo para modificarlo'),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              if (_selectedGrupo != null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmación'),
                      content: Text(
                          '¿Estás seguro de que quieres eliminar el grupo \'${_selectedGrupo!.nombre}\'?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cerrar el diálogo
                          },
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            gruposService.deleteGrupo(_selectedGrupo!);
                            Navigator.of(context).pop(); // Cerrar el diálogo
                          },
                          child: Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Selecciona un grupo para eliminarlo'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          gruposService.loadGrupos();
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: gruposService.grupos.length,
                itemBuilder: (BuildContext context, int index) {
                  final grupo = gruposService.grupos[index];
                  return GrupoCard(
                    grupo: grupo,
                    onTap: () {
                      setState(() {
                        _selectedGrupo = grupo;
                        print(_selectedGrupo!.nombre);
                      });
                    },
                    isSelected: _selectedGrupo == grupo,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
