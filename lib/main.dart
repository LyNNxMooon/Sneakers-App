import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sneakers_app/app.dart';
import 'local_db/hive_dao.dart';
import 'utils/dependency_injection_utils.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await LocalDbDAO.instance.initDB();
  await di.init();
  runApp(const MyApp());
}



