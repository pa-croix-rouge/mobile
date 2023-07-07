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
    final departmentCode = utf8.decode((jsonObject['departmentCode'] as String).runes.toList());
    final postalCode = utf8.decode((jsonObject['postalCode'] as String).runes.toList());
    final city = utf8.decode((jsonObject['city'] as String).runes.toList());
    final streetNumberAndName = utf8.decode((jsonObject['streetNumberAndName'] as String).runes.toList());

    return AddressDTO(
      departmentCode,
      postalCode,
      city,
      streetNumberAndName,
    );
  }
}
