import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/models.dart';
import '../actions/actions.dart';

class BootstrapPage extends StatelessWidget {
  BootstrapPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Body(
        store: StoreProvider.of<AppState>(context),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final Store<AppState> store;

  _Body({
    Key key,
    @required this.store,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  var _isFailed = false;

  @override
  void initState() {
    super.initState();

    _bootstrap();
  }

  void _bootstrap() {
    widget.store.dispatch(accountInfoAction(
      onSucceed: (user) {
        Navigator.of(context)
            .pushReplacementNamed(user.id == 0 ? '/login' : '/tab');
      },
      onFailed: (notice) {
        setState(() {
          _isFailed = true;
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
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(flex: 5),
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Image(
              image: AssetImage('assets/wg-icon-no-bg.png'),
            ),
          ),
          Spacer(),
          _isFailed
              ? Column(
                  children: <Widget>[
                    Text('网络请求出错'),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isFailed = false;
                        });
                        _bootstrap();
                      },
                      child: Text(
                        '再试一次',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    ),
                  ],
                )
              : Text('网络请求中...'),
          Spacer(flex: 5),
        ],
      ),
    );
  }
}
