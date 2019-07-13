import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:package_info/package_info.dart';

import 'app.dart';
import 'config.dart';
import 'factory.dart';

void main() async {
  WgConfig.packageInfo = await PackageInfo.fromPlatform();
  WgConfig.debug = true;
  WgConfig.loggerLevel = Level.ALL;
  WgConfig.isLogAction = true;
  WgConfig.isLogApi = true;
  WgConfig.isMockApi = true;

  final store = await WgFactory().getStore();

  runApp(WgApp(store));
}
