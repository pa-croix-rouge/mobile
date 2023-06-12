typedef DecodeJsonObjectFunction<T> = T Function(Map<String, dynamic>);
typedef EncodeJsonObjectFunction<T> = Map<String, dynamic> Function(T);

abstract class EncodableGeneric<GenericType> {
  Map<String, dynamic> encode(EncodeJsonObjectFunction<GenericType> encodeGeneric);
}

abstract class Decodable<OutputType, InputType> {
   OutputType decode(InputType jsonObject);
}
