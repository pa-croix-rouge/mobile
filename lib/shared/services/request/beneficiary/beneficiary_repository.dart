import 'package:pa_mobile/core/model/beneficiary/beneficiary_response_dto.dart';
import 'package:pa_mobile/shared/services/request/http_requests.dart';

class BeneficiaryRepository {
  static String get route => '/beneficiaries';
  static String get tokenRoute => '/beneficiaries/token';

  Future<BeneficiaryResponseDto> getBeneficiary() async {
    try {
      final response = await HttpRequests.get(tokenRoute);
      return BeneficiaryResponseDto.decode(response.body);
    } catch (e) {
      throw Exception('Failed to load beneficiary');
    }
  }
}
