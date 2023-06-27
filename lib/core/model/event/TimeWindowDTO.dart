import 'package:pa_mobile/core/utils/encode.dart';

class TimeWindowDTO {
  TimeWindowDTO(
    this.id,
    this.start,
    this.end,
    this.maxParticipants,
    this.participants,
  );

  final int id;
  final DateTime start;
  final DateTime end;
  final int maxParticipants;
  final List<int> participants;

  static TimeWindowDTO decode(Map<String, dynamic> jsonObject) {
    final id = jsonObject['timeWindowId'] as int;
    final start = EncodeTools.decodeDateTime( jsonObject['start'] as String);
    final end = EncodeTools.decodeDateTime( jsonObject['end'] as String);
    final maxParticipants = jsonObject['maxParticipants'] as int;
    final participants = <int>[];

    for(final element in jsonObject['participants'] as List<dynamic>) {
      participants.add(element as int);
    }

    return TimeWindowDTO(
      id,
      start,
      end,
      maxParticipants,
      participants,
    );
  }
}
