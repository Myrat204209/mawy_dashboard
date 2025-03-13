import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mawy_dashboard/app.dart';
import 'package:mawy_dashboard/hive/hive_registrar.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapters();

  await Hive.openBox("test1box");
  await Hive.openBox("test2box");
  await Hive.openBox("test3box");
  await Hive.openBox("test4box");

  runApp(ProviderScope(child: App()));
}

final keyBoxProvider = Provider((ref) => Hive.box("test1box"));
final loginBoxProvider = Provider((ref) => Hive.box("test2box"));
final newsIdBoxProvider = Provider((ref) => Hive.box("test3box"));
final authCheckBoxProvider = Provider((ref) => Hive.box("test4box"));
