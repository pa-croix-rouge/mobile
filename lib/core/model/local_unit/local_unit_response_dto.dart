import 'dart:convert';

import 'package:pa_mobile/core/model/address/address_dto.dart';
import 'package:pa_mobile/core/utils/encode.dart';

class LocalUnitResponseDTO extends Encodable {
  LocalUnitResponseDTO(
    this.id,
    this.name,
    this.address,
    this.managerName,
    this.code,
  );

  int id;
  String name;
  AddressDTO address;
  String managerName;
  String code;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'managerName': managerName,
      'code': code,
    };
  }

  @override
  String encode() {
    return jsonEncode(toJson());
  }

  static LocalUnitResponseDTO decode(Map<String, dynamic> jsonObject) {
    final id = jsonObject['id'] as int;
    final name = utf8.decode((jsonObject['name'] as String).runes.toList());
    final address = AddressDTO.decode(jsonObject['address'] as Map<String, dynamic>);
    final managerName = utf8.decode((jsonObject['managerName'] as String).runes.toList());
    final code = utf8.decode((jsonObject['code'] as String).runes.toList());

    return LocalUnitResponseDTO(
      id,
      name,
      address,
      managerName,
      code,
    );
  }
}
