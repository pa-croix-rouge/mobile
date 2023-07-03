import 'dart:convert';

import 'package:pa_mobile/core/model/event/TimeWindowDTO.dart';
import 'package:pa_mobile/core/utils/encode.dart';

class EventResponseDTO {
  EventResponseDTO(
      this.eventId,
      this.sessionId,
      this.name,
      this.description,
      this.start,
      this.end,
      this.referrerId,
      this.localUnitId,
      this.maxParticipants,
      this.numberOfParticipants,
      this.timeWindows,
      this.isRecurring,
      );

  final int eventId;
  final int sessionId;
  final String name;
  final String description;
  final DateTime start;
  final DateTime end;
  final int referrerId;
  final int localUnitId;
  final int maxParticipants;
  final int numberOfParticipants;
  final List<TimeWindowDTO> timeWindows;
  final bool isRecurring;

  static EventResponseDTO decode(Map<String, dynamic> jsonObject) {
    final eventId = jsonObject['eventId'] as int;
    final sessionId = jsonObject['sessionId'] as int;
    final name = utf8.decode((jsonObject['name'] as String).runes.toList());
    final description = utf8.decode((jsonObject['description'] as String).runes.toList());
    final start = EncodeTools.decodeDateTime( jsonObject['start'] as String);
    final end = EncodeTools.decodeDateTime( jsonObject['end'] as String);
    final referrerId = jsonObject['referrerId'] as int;
    final localUnitId = jsonObject['localUnitId'] as int;
    final maxParticipants = jsonObject['maxParticipants'] as int;
    final numberOfParticipants = jsonObject['numberOfParticipants'] as int;

    final timeWindows = <TimeWindowDTO>[];
    for (final element in jsonObject['timeWindows'] as List<dynamic>) {
      timeWindows.add(TimeWindowDTO.decode(element as Map<String, dynamic>));
    }

    final isRecurring = jsonObject['recurring'] as bool;

    return EventResponseDTO(
      eventId,
      sessionId,
      name,
      description,
      start,
      end,
      referrerId,
      localUnitId,
      maxParticipants,
      numberOfParticipants,
      timeWindows,
      isRecurring,
    );
  }

}
