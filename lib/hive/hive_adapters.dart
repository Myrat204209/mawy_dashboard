import 'package:hive_ce/hive.dart';
import 'package:mawy_dashboard/hive/hive_objects.dart';

part 'hive_adapters.g.dart';
@GenerateAdapters([
  AdapterSpec<AllKeys>(),
  AdapterSpec<Logins>(),
  AdapterSpec<NewsId>(),
  AdapterSpec<AuthCheck>(),
])
class HiveAdapters {}
