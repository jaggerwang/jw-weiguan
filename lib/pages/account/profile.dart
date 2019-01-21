import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../models/models.dart';
import '../../theme.dart';
import '../../actions/actions.dart';
import '../pages.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({
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
              title: Text('个人资料'),
            ),
            body: _Body(
              store: StoreProvider.of<AppState>(context),
              vm: vm,
            ),
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => InputPage(
                                  title: '设置用户名',
                                  hintText: '2-20 个中英文字符',
                                  initialValue: widget.vm.user.username,
                                  submit: ({input, onSucceed, onFailed}) =>
                                      widget.store.dispatch(accountEditAction(
                                        form: ProfileForm(username: input),
                                        onSucceed: (user) => onSucceed(),
                                        onFailed: onFailed,
                                      )),
                                ),
                          ),
                        ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    title: Text(
                      '用户名',
                      style: TextStyle(fontSize: WgTheme.fontSizeLarge),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          widget.vm.user.username,
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                  Divider(height: 1),
                  ListTile(
                    onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditMobilePage(
                                  initialForm: ProfileForm(
                                      mobile: widget.vm.user.mobile),
                                ),
                          ),
                        ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    title: Text(
                      '手机',
                      style: TextStyle(fontSize: WgTheme.fontSizeLarge),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          widget.vm.user.mobile.isEmpty
                              ? '未填写'
                              : widget.vm.user.mobile,
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                  Divider(height: 1),
                ],
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
