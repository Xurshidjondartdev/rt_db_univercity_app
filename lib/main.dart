import 'package:flutter/material.dart';
import 'package:rt_db_univercity_app/app.dart';
import 'package:rt_db_univercity_app/setup.dart';

Future<void> main() async {
  await setup();
  runApp(const App());
}
