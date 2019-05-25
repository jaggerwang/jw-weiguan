import 'dart:async';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'config.dart';
import 'services/services.dart';
import 'models/models.dart';
import 'reducers/reducers.dart';
import 'utils/string.dart';

class WgFactory {
  static WgFactory _singleton;

  Map<String, Logger> _loggers = {};
  Persistor<AppState> _persistor;
  Store<AppState> _store;
  PersistCookieJar _cookieJar;
  WgService _wgService;

  WgFactory._();

  factory WgFactory() {
    if (_singleton == null) {
      _singleton = WgFactory._();
    }
    return _singleton;
  }

  Logger getLogger(String name) {
    if (_loggers[name] == null) {
      Logger.root.level = WgConfig.loggerLevel;
      final logger = Logger(name);
      logger.onRecord
          .where((record) => record.loggerName == logger.name)
          .listen((record) {
        final label =
            record.loggerName.padRight(7).substring(0, 7).toUpperCase();
        final time = record.time.toIso8601String().substring(0, 23);
        final level = record.level.toString().padRight(7);
        print('$label $time $level ${record.message}');
      });
      _loggers[name] = logger;
    }
    return _loggers[name];
  }

  Persistor<AppState> getPersistor() {
    if (_persistor == null) {
      _persistor = Persistor<AppState>(
        storage: FlutterStorage(WgConfig.packageInfo.packageName),
        decoder: (json) {
          var state = AppState.fromJson(json);
          if (compareVersion(state.version, WgConfig.packageInfo.version, 2) !=
              0) {
            state = AppState();
          }
          return state;
        },
      );
    }
    return _persistor;
  }

  Store<AppState> getStore() {
    if (_store == null) {
      final List<Middleware<AppState>> wms = [];
      if (WgConfig.isLogAction) {
        wms.add(LoggingMiddleware<AppState>(
            logger: getLogger('action'), level: Level.FINE));
      }
      wms.addAll([
        thunkMiddleware,
        getPersistor().createMiddleware(),
      ]);

      _store = Store<AppState>(
        appReducer,
        initialState: AppState(),
        middleware: wms,
      );
    }
    return _store;
  }

  Future<PersistCookieJar> getCookieJar() async {
    if (_cookieJar == null) {
      var docDir = await getApplicationDocumentsDirectory();
      _cookieJar = PersistCookieJar(dir: '${docDir.path}/cookies');
    }
    return _cookieJar;
  }

  Future<WgService> getWgService() async {
    if (_wgService == null) {
      var cookieJar = await getCookieJar();
      _wgService = WgService(cookieJar);
    }
    return _wgService;
  }
}
