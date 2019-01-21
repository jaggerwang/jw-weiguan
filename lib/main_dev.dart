import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:package_info/package_info.dart';

import 'app.dart';
import 'config.dart';

void main() {
  PackageInfo.fromPlatform().then((packageInfo) {
    WgConfig.packageInfo = packageInfo;
    WgConfig.debug = true;
    WgConfig.loggerLevel = Level.ALL;
    WgConfig.isLogAction = true;
    WgConfig.isLogApi = true;
    WgConfig.isMockApi = true;

    runApp(WgApp());
  });
}
