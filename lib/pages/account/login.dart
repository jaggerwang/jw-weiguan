import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/models.dart';
import '../../theme.dart';
import '../../actions/actions.dart';

class LoginPage extends StatelessWidget {
  LoginPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  _Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _formKey = GlobalKey<FormState>();
  final _form = LoginForm();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  var _isLoading = false;

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });

      StoreProvider.of<AppState>(context).dispatch(accountLoginAction(
        onSucceed: (UserEntity user) {
          setState(() {
            _isLoading = false;
          });

          Navigator.of(context).pushReplacementNamed('/tab');
        },
        onFailed: (NoticeEntity notice) {
          setState(() {
            _isLoading = false;
          });

          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(notice.message),
            duration: notice.duration,
          ));
        },
        form: _form,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          padding: EdgeInsets.all(WgTheme.paddingSizeNormal),
          children: <Widget>[
            Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.account_circle),
                          hintText: '用户名',
                        ),
                        onSaved: (value) => _form.username = value,
                        focusNode: _usernameFocus,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () {
                          _usernameFocus.unfocus();
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.vpn_key),
                          hintText: '密码',
                        ),
                        obscureText: true,
                        onSaved: (value) => _form.password = value,
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: _submit,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: WgTheme.marginSizeNormal),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                padding:
                                    EdgeInsets.all(WgTheme.paddingSizeNormal),
                                onPressed: _submit,
                                color: Theme.of(context).primaryColorDark,
                                child: Text(
                                  '登录',
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
                    ],
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '还没有帐号？',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                    FlatButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/register'),
                      child: Text(
                        '注册一个',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    ),
                  ],
                ),
              ],
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
