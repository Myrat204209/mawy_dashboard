import 'package:hive_ce_flutter/hive_flutter.dart';

class AllKeys extends HiveObject {
  AllKeys({required this.keys});
  final Map<String, Map<String, Map<String, String>>> keys;
}

class Logins extends HiveObject {
  Logins({
    required this.logins,
    required this.passwords,
    required this.keys,
    required this.check,
  });

  final String logins;
  final String passwords;
  final String keys;
  final bool check;
}

class NewsId extends HiveObject {
  NewsId({required this.nCount});

  final List nCount;
}

class AuthCheck extends HiveObject {
  AuthCheck({
    required this.check,
    required this.logins,
    required this.passwords,
    required this.keys,
  });

  bool check;
  String logins;
  String passwords;
  String keys;
}
