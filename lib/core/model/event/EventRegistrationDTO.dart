import 'dart:convert';

import 'package:pa_mobile/core/utils/encode.dart';

class EventRegistrationDTO extends Encodable {
  EventRegistrationDTO(
    this.eventId,
    this.sessionId,
    this.timeWindowId,
    this.participantId,
  );

  int eventId;
  int sessionId;
  int timeWindowId;
  int participantId;

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'sessionId': sessionId,
      'timeWindowId': timeWindowId,
      'participantId': participantId,
    };
  }

  @override
  String encode() {
    return jsonEncode(toJson());
  }
}
