import 'dart:convert';

import 'package:pa_mobile/core/model/local_unit/local_unit_response_dto.dart';
import 'package:pa_mobile/shared/services/request/http_requests.dart';

class Register {
  static String get route => '/localunit';

  //get all local units
  static Future<List<LocalUnitResponseDTO>> loadLocalUnit() async {
    final response = await HttpRequests.get(route);
    print(response.statusCode);
    print(response.body);
    switch (response.statusCode) {
      case 200:
        final list = <LocalUnitResponseDTO>[];
        for (final element in jsonDecode(response.body) as List<dynamic>) {
          list.add(LocalUnitResponseDTO.decode(element as Map<String, dynamic>));
        }
        return list;
      default:
        return [];
    }
  }
}
