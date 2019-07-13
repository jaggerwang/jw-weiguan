import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'models/models.dart';
import 'theme.dart';
import 'config.dart';
import 'factory.dart';
import 'pages/pages.dart';

class WgApp extends StatelessWidget {
  final logger = WgFactory().getLogger('app');
  final Store<AppState> store;

  WgApp(this.store) {
    logger.info(
        'WgConfig(debug: ${WgConfig.debug}, loggerLevel: ${WgConfig.loggerLevel})');
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: WgConfig.packageInfo.appName,
        theme: WgTheme.theme,
        routes: {
          '/': (context) => BootstrapPage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/tab': (context) => TabPage(),
        },
      ),
    );
  }
}
