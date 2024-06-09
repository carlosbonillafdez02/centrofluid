import 'package:fl_centro_fluid/providers/providers.dart';
import 'package:fl_centro_fluid/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Usuario usuario =
        Provider.of<ConnectedUserProvider>(context).activeUser;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 50),
          child: Column(
            children: [
              MiAppBar(),
              TabBar(
                tabs: [
                  usuario.rol != "entrenador"
                      ? Tab(text: 'Mis Clases Próximas')
                      : Tab(text: 'Clases Próximas'),
                  usuario.rol != "entrenador"
                      ? Tab(text: 'Mis Clases Pasadas')
                      : Tab(text: 'Clases Pasadas'),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildClasesProximas(context, usuario),
            _buildClasesPasadas(context, usuario),
          ],
        ),
      ),
    );
  }

  Widget _buildClasesProximas(BuildContext context, Usuario usuario) {
    final clasesService = Provider.of<ClasesService>(context);
    final Future<List<Clase>> futureClases = (usuario.rol != "entrenador")
        ? clasesService.getClienteClasesActuales(usuario.id!)
        : clasesService.getAllClasesActuales();

    return FutureBuilder<List<Clase>>(
      future: futureClases,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(context, usuario,
              'No tienes clases reservadas', 'No hay clases próximas');
        }

        List<Clase> clases = snapshot.data!;

        return ListView.builder(
          itemCount: clases.length,
          itemBuilder: (context, index) {
            final clase = clases[index];
            return ClaseCard(
              clase: clase,
            );
          },
        );
      },
    );
  }

  Widget _buildClasesPasadas(BuildContext context, Usuario usuario) {
    final clasesService = Provider.of<ClasesService>(context);
    final Future<List<Clase>> futureClases = (usuario.rol != "entrenador")
        ? clasesService.getClienteClasesPasadas(usuario.id!)
        : clasesService.getAllClasesPasadas();

    return FutureBuilder<List<Clase>>(
      future: futureClases,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(context, usuario, 'No tienes clases pasadas',
              'No hay clases pasadas');
        }

        List<Clase> clases = snapshot.data!;

        return ListView.builder(
          itemCount: clases.length,
          itemBuilder: (context, index) {
            final clase = clases[index];
            return ClaseCard(
              clase: clase,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, Usuario usuario,
      String clienteMensaje, String entrenadorMensaje) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30.0),
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(5, 5),
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              usuario.rol != "entrenador" ? clienteMensaje : entrenadorMensaje,
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyBottomNavBar(index: 1),
                  ),
                );
              },
              child: Text("Ir a calendario de reservas"),
            ),
          ],
        ),
      ),
    );
  }
}
