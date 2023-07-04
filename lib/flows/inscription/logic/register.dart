import 'dart:convert';

import 'package:pa_mobile/core/model/authentication/beneficiary_creation_request.dart';
import 'package:pa_mobile/core/model/local_unit/local_unit_response_dto.dart';
import 'package:pa_mobile/shared/services/request/http_requests.dart';

class Register {
  static String get route => '/localunit';
  static String get inscription => '/beneficiaries/register';

  static Future<List<LocalUnitResponseDTO>> loadLocalUnit() async {
    final response = await HttpRequests.get(route);
    print(utf8.decode(response.body.runes.toList()));
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

  static Future<bool> registerBeneficiary(BeneficiaryCreationRequest dto) async {
    final response = await HttpRequests.post(inscription, dto.encode(), null);
    print(response.statusCode);
    print(response.body);
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }
}
