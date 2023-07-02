import 'dart:convert';

import 'package:pa_mobile/core/utils/encode.dart';

class AddressDTO extends Encodable{
  AddressDTO(
    this.departmentCode,
    this.postalCode,
    this.city,
    this.streetNumberAndName,
  );

  String departmentCode;
  String postalCode;
  String city;
  String streetNumberAndName;

  Map<String, dynamic> toJson() {
    return {
      'departmentCode': departmentCode,
      'postalCode': postalCode,
      'city': city,
      'streetNumberAndName': streetNumberAndName,
    };
  }

  @override
  String encode() {
    return jsonEncode(toJson());
  }

  static AddressDTO decode(Map<String, dynamic> jsonObject) {
    final departmentCode = jsonObject['departmentCode'] as String;
    final postalCode = jsonObject['postalCode'] as String;
    final city = jsonObject['city'] as String;
    final streetNumberAndName = jsonObject['streetNumberAndName'] as String;

    return AddressDTO(
      departmentCode,
      postalCode,
      city,
      streetNumberAndName,
    );
  }
}
