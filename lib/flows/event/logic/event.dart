import 'dart:convert';
import 'dart:ffi';

import 'package:pa_mobile/core/model/event/EventResponseDTO.dart';

import 'package:pa_mobile/shared/services/request/http_requests.dart';

import '../../../core/model/event/EventRegistrationDTO.dart';

class EventLogic {
  static String get eventRoot => '/event';

  static Future<List<EventResponseDTO>> getLocalUnitEvent(String id) async {
    final response = await HttpRequests.get('$eventRoot/all/$id', null);

    switch (response.statusCode) {
      case 200:
        final list = <EventResponseDTO>[];
        for (final element in jsonDecode(response.body) as List<dynamic>) {
          list.add(EventResponseDTO.decode(element as Map<String, dynamic>));
        }
        return list;
      default:
        throw Exception('Error${response.statusCode}');
    }
  }

  static Future<void> registerToEvent(EventRegistrationDTO dto) async {
    final response = await HttpRequests.post(
      '$eventRoot/register/',
      dto.encode(),
      null,
    );

    switch (response.statusCode) {
      case 200:
        return;
      default:
        throw Exception('Error${response.statusCode}');
    }
  }
}
