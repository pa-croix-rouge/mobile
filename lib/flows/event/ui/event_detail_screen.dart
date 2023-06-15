import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pa_mobile/core/model/event/EventRegistrationDTO.dart';
import 'package:pa_mobile/core/model/event/EventResponseDTO.dart';
import 'package:pa_mobile/flows/authentication/ui/login_screen.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/stay_login_secure_storage.dart';

import '../logic/event.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key, required this.event});

  final EventResponseDTO event;

  static const routeName = '/event';

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final dateFormat = DateFormat.Hms();

  Future<void> onJoin(int timeWindowID) async {
    try {
      await EventLogic.registerToEvent( EventRegistrationDTO(
          widget.event.eventId, widget.event.sessionId, timeWindowID, 0,
        ),
      );
    } catch (e) {
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.event.name),
          Text(widget.event.description),
          Expanded(
            child: ListView.separated(
              itemCount: widget.event.timeWindows.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: [
                      Text(
                          '${dateFormat.format(widget.event.timeWindows[index].start)} - ${dateFormat.format(widget.event.timeWindows[index].end)}'),
                      Text(
                          '${widget.event.timeWindows[index].maxParticipants}'),
                      OutlinedButton(
                        onPressed: () =>
                            onJoin(widget.event.timeWindows[index].id),
                        child: const Text("S'inscrire"),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 8.0);
              },
            ),
          ),
        ],
      ),
    );
  }
}
