import 'dart:convert';

abstract class Encodable {
  String encode();
}

class EncodeTools {

  static DateTime decodeDateTime(String strDate) {
    final i = strDate.indexOf('[');
    if(i != -1) {
      return DateTime.parse( strDate.substring(0, i) );
    }
   return DateTime.parse( strDate );
  }

  static String decodeString(String body, String key) {
    try {
      final jsonObject = jsonDecode(body);
      return utf8.decode(_validateField<String>(jsonObject, key).runes.toList());
    } catch (e) {
      throw Exception('error decoding string');
    }
  }

  static int decodeInt(String body, String key) {
    try {
      final jsonObject = jsonDecode(body);
      return _validateField<int>(jsonObject, key);
    } catch (e) {
      throw Exception('error decoding int');
    }
  }

  static bool decodeBool(String body, String s) {
    try {
      final jsonObject = jsonDecode(body);
      return _validateField<bool>(jsonObject, s);
    } catch (e) {
      throw Exception('error decoding bool');
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
