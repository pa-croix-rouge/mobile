import 'package:flutter/material.dart';
import 'package:pa_mobile/core/model/beneficiary/beneficiary_response_dto.dart';
import 'package:pa_mobile/core/model/event/EventResponseDTO.dart';
import 'package:pa_mobile/flows/authentication/ui/login_screen.dart';
import 'package:pa_mobile/flows/event/logic/event.dart';
import 'package:pa_mobile/flows/event/ui/event_detail_screen.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/stay_login_secure_storage.dart';
import 'package:table_calendar/table_calendar.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  static const routeName = '/event';

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  DateTime _selectedDay = DateTime.now();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  List<EventResponseDTO> localUnitEvents = [];
  late final ValueNotifier<List<EventResponseDTO>> selectedEvent;

  late BeneficiaryResponseDto beneficiary;

  List<EventResponseDTO> _getEventsForDay(DateTime day) {
    return localUnitEvents
        .where((event) => isSameDay(event.start, day))
        .toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
      });

      selectedEvent.value = _getEventsForDay(selectedDay);
    }
  }

  Future<List<EventResponseDTO>> load() async {
    final res = await Future.wait([
      EventLogic.getConnectBeneficiary()
    ]);

    beneficiary = res[0];
    return EventLogic.getLocalUnitEvent(beneficiary.localUnitId.toString());
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    selectedEvent = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  @override
  void dispose() {
    selectedEvent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: load(),
      builder: (context, AsyncSnapshot<List<EventResponseDTO>> snapshot) {
        if (snapshot.hasError) {
          JwtSecureStorage().deleteJwtToken();
          StayLoginSecureStorage().notStayLogin();
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.routeName,
            (route) => false,
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        localUnitEvents = snapshot.data!;
        selectedEvent.value = _getEventsForDay(_selectedDay);
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              surface: Colors.blueGrey,
              onSurface: Colors.yellow,
            ),
          ),
          child: Column(
            children: [
              TableCalendar<EventResponseDTO>(
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                  rangeHighlightColor: Colors.red,
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                ),
                firstDay: DateTime.utc(1999),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _selectedDay,
                locale: 'fr_FR',
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                calendarFormat: _calendarFormat,
                onDaySelected: _onDaySelected,
                eventLoader: _getEventsForDay,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _selectedDay = focusedDay;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ValueListenableBuilder<List<EventResponseDTO>>(
                  valueListenable: selectedEvent,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute<EventDetailScreen>(
                                  builder: (context) => EventDetailScreen(
                                    event: value[index],
                                    beneficiary: beneficiary,
                                  ),
                                )),
                            title: Text(value[index].name),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
