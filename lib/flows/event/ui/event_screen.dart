import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pa_mobile/core/model/volonteer/volunteer_response_dto.dart';
import 'package:pa_mobile/flows/authentication/ui/login_screen.dart';
import 'package:pa_mobile/flows/event/logic/event.dart';
import 'package:pa_mobile/flows/event/ui/event_detail_screen.dart';
import 'package:pa_mobile/flows/home/logic/home.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/stay_login_secure_storage.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/model/event/EventResponseDTO.dart';

class EventScreen extends StatefulWidget {
  static const routeName = '/event';

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  DateTime _selectedDay = DateTime.now();

  List<EventResponseDTO> localUnitEvents = [];
  late final ValueNotifier<List<EventResponseDTO>> selectedEvent;

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

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime(2000, 06, 1);
    selectedEvent = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    selectedEvent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Text('Account'),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await JwtSecureStorage().deleteJwtToken();
            await StayLoginSecureStorage().notStayLogin();
            await Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (route) => false);
          },
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: EventLogic.getLocalUnitEvent('1'),
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
              return const CircularProgressIndicator();
            }
            localUnitEvents = snapshot.data!;
            return Column(
              children: [
                TableCalendar<EventResponseDTO>(
                  firstDay: DateTime.utc(1999, 1, 1),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _selectedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: _onDaySelected,
                  eventLoader: _getEventsForDay,
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ValueListenableBuilder<List<EventResponseDTO>>(
                    valueListenable: selectedEvent,
                    builder: (context, value, _) {
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EventDetailScreen(event: value[index]),
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
            );
          },
        ),
      ),
    );
  }
}
