import 'package:pa_mobile/core/model/volonteer/volunteer_response_dto.dart';
import 'package:pa_mobile/shared/services/request/http_requests.dart';

class Home {
  static String get volunteerInfoRoute => '/volunteer/token';

  static Future<VolunteerResponseDto> getVolunteerInfo() async {
    final response = await HttpRequests.get(volunteerInfoRoute, null);

    print("object");
    switch (response.statusCode) {
      case 200:
        print(response.body);
        return VolunteerResponseDto.decode(response.body);
      default:
       throw Exception('Failed to load volunteer info');
    }
  }
}