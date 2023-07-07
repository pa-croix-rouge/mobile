import 'dart:convert';

import 'package:pa_mobile/core/model/authentication/beneficiary_creation_request.dart';
import 'package:pa_mobile/core/model/beneficiary/beneficiary_response_dto.dart';
import 'package:pa_mobile/core/model/local_unit/local_unit_response_dto.dart';
import 'package:pa_mobile/core/model/volonteer/volunteer_response_dto.dart';
import 'package:pa_mobile/shared/services/request/http_requests.dart';

class Account {
  static String get beneficiaryInfoRoute => '/beneficiaries';

  static Future<BeneficiaryResponseDto> getBeneficiaryInfo() async {
    final response = await HttpRequests.get(
      '$beneficiaryInfoRoute/token',
    );

    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        return BeneficiaryResponseDto.decode(response.body);
      default:
        throw Exception('Failed to load beneficiary info');
    }
  }

  static Future<LocalUnitResponseDTO> getLocalUnit(String id) async {
    final response = await HttpRequests.get(
      '/localunit/$id',
    );

    print(response.body);
    switch (response.statusCode) {
      case 200:
        return LocalUnitResponseDTO.decode(jsonDecode(response.body) as Map<String, dynamic>);
      default:
        throw Exception('Failed to load local unit');
    }
  }

  static Future<void> modifyBeneficiaryInfo(BeneficiaryCreationRequest dto, int id) async {
    final response = await HttpRequests.put(
      '$beneficiaryInfoRoute/${id}',
      dto.encode(),
      null,
    );

    switch (response.statusCode) {
      case 200:
        return;
      default:
        throw Exception('Failed to modify beneficiary info');
    }
  }
}
