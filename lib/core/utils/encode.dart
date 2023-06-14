import 'dart:convert';

abstract class Encodable {
  String encode();
}

class EncodeTools {
  static String decodeString(String body, String key) {
    try {
      final jsonObject = jsonDecode(body);
      return _validateField<String>(jsonObject, key);
    } catch (e) {
      throw Exception('error decoding string');
    }
  }

  static T _validateField<T>(dynamic dict, String key) {
    final dynamic value = dict[key];
    if (value == null || !checkType<T>(value)) {
      print('error $key is null or not a $T');

      throw Exception('wanted a $T type but got a ${value.runtimeType}');
    }
    return value as T;
  }

  static bool checkType<T>(dynamic value) {
    return value is T;
  }
}
