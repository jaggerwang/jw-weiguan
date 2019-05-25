import 'dart:async';

import 'package:flutter/material.dart';

import '../components/components.dart';

class TabPage extends StatefulWidget {
  static final globalKey = GlobalKey<_TabPageState>();

  TabPage() : super(key: globalKey);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  final _navigatorKeys = WgTabBar.tabs
      .map<GlobalKey<NavigatorState>>((v) => GlobalKey<NavigatorState>())
      .toList();
  final _focusScopeNodes =
      WgTabBar.tabs.map<FocusScopeNode>((v) => FocusScopeNode()).toList();
  var _tabIndex = 0;

  void switchTab(int index) {
    setState(() {
      _tabIndex = index;
    });

    // FixBug: Offstage widget not auto loose focus
    FocusScope.of(context).setFirstFocus(_focusScopeNodes[index]);
  }

  Future<bool> _onWillPop() async {
    final maybePop = await _navigatorKeys[_tabIndex].currentState.maybePop();
    return Future.value(!maybePop);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: IndexedStack(
        index: _tabIndex,
        children: WgTabBar.tabs
            .asMap()
            .entries
            .map<Widget>(
              (entry) => FocusScope(
                    node: _focusScopeNodes[entry.key],
                    child: Navigator(
                      key: _navigatorKeys[entry.key],
                      onGenerateRoute: (settings) {
                        WidgetBuilder builder;
                        switch (settings.name) {
                          case '/':
                            builder = entry.value['builder'];
                            break;
                          default:
                            throw Exception('Invalid route: ${settings.name}');
                        }
                        return MaterialPageRoute(
                          builder: builder,
                          settings: settings,
                        );
                      },
                    ),
                  ),
            )
            .toList(),
      ),
    );
  }
}
