import 'package:flutter/material.dart';

import '../../pages/pages.dart';

class WgTabBar extends StatelessWidget {
  static final tabs = [
    {
      'title': Text('首页'),
      'icon': Icon(Icons.home),
      'builder': (BuildContext context) => HomePage(),
    },
    {
      'title': Text('发布'),
      'icon': Icon(Icons.add),
      'builder': (BuildContext context) => PublishPage(),
    },
    {
      'title': Text('我'),
      'icon': Icon(Icons.account_circle),
      'builder': (BuildContext context) => MePage(),
    },
  ];

  final int tabIndex;

  WgTabBar({
    Key key,
    this.tabIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: tabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => TabPage.globalKey.currentState.switchTab(index),
      items: tabs
          .map<BottomNavigationBarItem>(
            (v) => BottomNavigationBarItem(
                  icon: v['icon'],
                  title: v['title'],
                ),
          )
          .toList(),
    );
  }
}
