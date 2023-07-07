import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pa_mobile/core/model/beneficiary/beneficiary_response_dto.dart';
import 'package:pa_mobile/core/model/event/EventRegistrationDTO.dart';
import 'package:pa_mobile/core/model/event/EventResponseDTO.dart';
import 'package:pa_mobile/flows/event/logic/event.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen(
      {super.key, required this.event, required this.beneficiary});

  final EventResponseDTO event;
  final BeneficiaryResponseDto beneficiary;

  static const routeName = '/event';

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final dateFormat = DateFormat.Hm();

  Future<void> onJoin(int timeWindowIndex) async {
    print('onJoin');
    try {
      await EventLogic.registerToEvent(
        EventRegistrationDTO(
          widget.event.eventId,
          widget.event.sessionId,
          widget.event.timeWindows[timeWindowIndex].id,
          widget.beneficiary.id,
        ),
      );
      setState(() {
        widget.event.timeWindows[timeWindowIndex].participants
            .add(widget.beneficiary.id);
      });
    } catch (e) {
      print(e);
    }
  }

  bool isJoined(int timeWindowIndex) {
    return widget.event.timeWindows[timeWindowIndex].participants
        .contains(widget.beneficiary.id);
  }

  bool isFull(int timeWindowIndex) {
    return widget.event.timeWindows[timeWindowIndex].participants.length >=
        widget.event.timeWindows[timeWindowIndex].maxParticipants;
  }

  Future<void> onLeave(int timeWindowIndex) async {
    print('leave');
    try {
      await EventLogic.removeToEvent(
        EventRegistrationDTO(
          widget.event.eventId,
          widget.event.sessionId,
          widget.event.timeWindows[timeWindowIndex].id,
          widget.beneficiary.id,
        ),
      );
      setState(() {
        widget.event.timeWindows[timeWindowIndex].participants
            .remove(widget.beneficiary.id);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Evenement'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            widget.event.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Text(
            widget.event.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: widget.event.timeWindows.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateFormat
                                .format(widget.event.timeWindows[index].start),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(50, 5, 0, 5),
                            child: Text(
                              '${widget.event.timeWindows[index].participants.length} / ${widget.event.timeWindows[index].maxParticipants} participants',
                              style: TextStyle(
                                color:
                                    isFull(index) ? Colors.red : Colors.green,
                              ),
                            ),
                          ),
                          Text(dateFormat
                              .format(widget.event.timeWindows[index].end)),
                        ],
                      ),
                      if (!widget.event.timeWindows[index].end
                          .isBefore(DateTime.now()))
                        OutlinedButton(
                          onPressed: isFull(index) && !isJoined(index)
                              ? null
                              : () => isJoined(index)
                                  ? onLeave(index)
                                  : onJoin(index),
                          child: widget.event.timeWindows[index].participants
                                  .contains(widget.beneficiary.id)
                              ? const Text("Se désinscrire")
                              : const Text("S'inscrire"),
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
