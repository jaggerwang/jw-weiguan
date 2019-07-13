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

  Future<Store<AppState>> getStore() async {
    if (_store == null) {
      final persistor = Persistor<AppState>(
        storage: FlutterStorage(key: WgConfig.packageInfo.packageName),
        serializer: JsonSerializer<AppState>((json) {
          if (json == null) {
            return AppState();
          }
          return AppState.fromJson(json);
        }),
        transforms: Transforms(
          onLoad: [
            (state) {
              if (compareVersion(
                      state.version, WgConfig.packageInfo.version, 2) !=
                  0) {
                state = AppState();
              }
              return state;
            }
          ],
        ),
      );

      final initialState = await persistor.load();

      final List<Middleware<AppState>> wms = [];
      if (WgConfig.isLogAction) {
        wms.add(LoggingMiddleware<AppState>(
            logger: getLogger('action'), level: Level.FINE));
      }
      wms.addAll([
        thunkMiddleware,
        persistor.createMiddleware(),
      ]);

      _store = Store<AppState>(
        appReducer,
        initialState: initialState ?? AppState(),
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
