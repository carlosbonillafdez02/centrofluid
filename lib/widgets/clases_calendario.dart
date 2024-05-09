import 'package:fl_centro_fluid/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_centro_fluid/screens/screens.dart';

class ClasesCalendario extends StatefulWidget {
  const ClasesCalendario({Key? key}) : super(key: key);

  @override
  State<ClasesCalendario> createState() => _ClasesCalendarioState();
}

class _ClasesCalendarioState extends State<ClasesCalendario> {
  late ValueNotifier<List<Clase>> _selectedSchedule;

  final CalendarFormat _calendarFormat = CalendarFormat.week;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.disabled;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  //List<Sesion> _sesionesDia = [];
  //late SesionesServices _sesionesServices = SesionesServices();
  late ClasesService _clasesServices = ClasesService();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _clasesServices = Provider.of<ClasesService>(context);

    //usuarioActivo = Provider.of<ConnectedUserProvider>(context).activeUser;
    _selectedSchedule = ValueNotifier(_cargarClasesDia(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedSchedule.dispose();
    super.dispose();
  }

  List<Clase> _cargarClasesDia(DateTime fecha) {
    return _clasesServices.getClasesDia(fecha);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedSchedule.value = _cargarClasesDia(_selectedDay!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_clasesServices.isLoading) {
      return Expanded(
          child: Center(
              child: CircularProgressIndicator(color: AppTheme.primary)));
    }
    return Expanded(
        child: RefreshIndicator(
      onRefresh: () async {
        // Aquí puedes colocar el código para recargar los datos, como cargar las clases del día actual
        _clasesServices.loadClases();
      },
      child: Column(
        children: [
          TableCalendar(
            locale: 'es_ES',
            firstDay: DateTime(DateTime.now().year - 1),
            lastDay: DateTime(DateTime.now().year + 1),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            availableCalendarFormats: const {CalendarFormat.week: 'week'},
            rangeSelectionMode: _rangeSelectionMode,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              /*
              outsideDecoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              outsideTextStyle: TextStyle(color: Colors.black),
              */
            ),
            headerStyle: const HeaderStyle(
              titleCentered: true,
            ),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, _) {
                final eventos = _cargarClasesDia(day);
                if (eventos.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTheme
                          .primary, // Cambia el color del fondo del día que tiene eventos
                      shape: BoxShape
                          .circle, // Cambia la forma del fondo del día que tiene eventos
                    ),
                    child: Text(
                      day.day
                          .toString(), // Puedes mostrar el número del día o cualquier otro texto
                      style: const TextStyle(
                        color: Colors
                            .white, // Cambia el color del texto del día que tiene eventos
                      ),
                    ),
                  );
                } else {
                  return null; // Devuelve null para usar el constructor de día predeterminado para los días sin eventos
                }
              },
            ),
          ),
          SizedBox(
            height: 15,
          ),
          ValueListenableBuilder<List<Clase>>(
            valueListenable: _selectedSchedule,
            builder: (context, clases, _) {
              if (clases.isEmpty) {
                return Container(
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          )
                        ]),
                    child: const Text(
                      'Hoy no hay clases',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: clases.length,
                  itemBuilder: (context, index) {
                    return ClaseCard(clase: clases[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    ));
  }
}
