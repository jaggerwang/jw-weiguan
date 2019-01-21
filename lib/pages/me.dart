import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../components/components.dart';
import '../config.dart';
import '../models/models.dart';
import '../theme.dart';
import '../actions/actions.dart';
import 'pages.dart';

class MePage extends StatelessWidget {
  static final _bodyKey = GlobalKey<_BodyState>();

  MePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
            user: store.state.account.user,
          ),
      builder: (context, vm) => Scaffold(
            appBar: AppBar(
              title: Text('我'),
            ),
            body: _Body(
              key: _bodyKey,
              store: StoreProvider.of<AppState>(context),
              vm: vm,
            ),
            bottomNavigationBar: WgTabBar(tabIndex: 2),
          ),
    );
  }
}

class _ViewModel {
  final UserEntity user;

  _ViewModel({
    @required this.user,
  });
}

class _Body extends StatefulWidget {
  final Store<AppState> store;
  final _ViewModel vm;

  _Body({
    Key key,
    @required this.store,
    @required this.vm,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    _loadAccountInfo();
  }

  void _loadAccountInfo() {
    setState(() {
      _isLoading = true;
    });

    widget.store.dispatch(accountInfoAction(
      onSucceed: (user) {
        setState(() {
          _isLoading = false;
        });
      },
      onFailed: (notice) {
        setState(() {
          _isLoading = false;
        });

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ));
      },
    ));
  }

  void _logout() {
    setState(() {
      _isLoading = true;
    });

    widget.store.dispatch(accountLogoutAction(
      onSucceed: () {
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context, rootNavigator: true)
            .pushReplacementNamed('/login');
      },
      onFailed: (notice) {
        setState(() {
          _isLoading = false;
        });

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ));
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        )),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    leading: GestureDetector(
                      onTap: Feedback.wrapForTap(
                        () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UserPage(userId: widget.vm.user.id),
                            )),
                        context,
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: widget.vm.user.avatar == ''
                            ? null
                            : CachedNetworkImageProvider(widget.vm.user.avatar),
                        child: widget.vm.user.avatar == ''
                            ? Icon(Icons.account_circle)
                            : null,
                      ),
                    ),
                    title: Text(
                      widget.vm.user.username,
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      '${widget.vm.user.mobile.isEmpty ? '尚未填写手机' : widget.vm.user.mobile}',
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              PostsLikedPage(userId: widget.vm.user.id),
                        )),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    title: Text(
                      '喜欢',
                      style: TextStyle(fontSize: WgTheme.fontSizeLarge),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                  Divider(height: 1),
                  ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              UsersFollowingPage(userId: widget.vm.user.id),
                        )),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    title: Text(
                      '关注',
                      style: TextStyle(fontSize: WgTheme.fontSizeLarge),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                  Divider(height: 1),
                  ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              FollowersPage(userId: widget.vm.user.id),
                        )),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    title: Text(
                      '粉丝',
                      style: TextStyle(
                        fontSize: WgTheme.fontSizeLarge,
                      ),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: WgTheme.marginSizeNormal),
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      padding: EdgeInsets.all(WgTheme.paddingSizeNormal),
                      onPressed: _logout,
                      color: Theme.of(context).primaryColorDark,
                      child: Text(
                        '退出',
                        style: TextStyle(
                          color: WgTheme.whiteLight,
                          fontSize: WgTheme.fontSizeLarge,
                          letterSpacing: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '${WgConfig.packageInfo.appName} v${WgConfig.packageInfo.version}@${WgConfig.domain}',
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ),
          ],
        ),
        Visibility(
          visible: _isLoading,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
