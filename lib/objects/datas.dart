import 'dart:convert';

Map<String, Map<String, Map<String, String>>> datasFromJson(String str) {
  final jsonMap = json.decode(str) as Map<String, dynamic>;
  final result = <String, Map<String, Map<String, String>>> {};

  for (final key in jsonMap.keys) {
    final innerMap = jsonMap[key] as Map<String, dynamic>;
    final innerResult = <String, Map<String, String>> {};

    for (final innerKey in innerMap.keys) {
      final innerInnerMap = innerMap[innerKey] as Map<String, dynamic>;
      innerResult[innerKey] = Map<String, String>.from(innerInnerMap);
    }

    result[key] = innerResult;
  }

  return result;
}
