import 'package:pa_mobile/core/model/beneficiary/beneficiary_response_dto.dart';
import 'package:pa_mobile/core/model/volonteer/volunteer_response_dto.dart';
import 'package:pa_mobile/shared/services/request/http_requests.dart';

class Home {
  static String get beneficiaryInfoRoute => '/beneficiaries/token';

  static Future<BeneficiaryResponseDto> getBeneficiaryInfo() async {
    final response = await HttpRequests.get(
      beneficiaryInfoRoute,
    );

    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print(response.body);
        return BeneficiaryResponseDto.decode(response.body);
      default:
        throw Exception('Failed to load beneficiary info');
    }
  }
}
