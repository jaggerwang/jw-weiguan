import 'package:package_info/package_info.dart';

import 'package:logging/logging.dart';

class WgConfig {
  static PackageInfo packageInfo;
  static var domain = 'weiguan.app';
  static var wgApiBaseUrl = 'https://$domain/api';
  static var debug = false;
  static var loggerLevel = Level.INFO;
  static var isLogAction = false;
  static var isLogApi = false;
  static var isMockApi = false;
}
