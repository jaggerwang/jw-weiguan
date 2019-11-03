import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../theme.dart';
import '../../models/models.dart';
import '../../actions/actions.dart';

class EditMobilePage extends StatelessWidget {
  static final _bodyKey = GlobalKey<_BodyState>();

  final ProfileForm initialForm;

  EditMobilePage({
    Key key,
    initialForm,
  })  : this.initialForm = initialForm ?? ProfileForm(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置手机'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _bodyKey.currentState.submit(),
            child: Text(
              '完成',
              style: TextStyle(
                color: WgTheme.whiteNormal,
                fontSize: WgTheme.fontSizeLarge,
              ),
            ),
          ),
        ],
      ),
      body: _Body(
        key: _bodyKey,
        store: StoreProvider.of<AppState>(context),
        initialForm: initialForm,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final Store<AppState> store;
  final ProfileForm initialForm;

  _Body({
    Key key,
    @required this.store,
    @required this.initialForm,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _formKey = GlobalKey<FormState>();
  ProfileForm _form;

  @override
  void initState() {
    super.initState();

    _form = widget.initialForm;
  }

  void submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      widget.store.dispatch(accountEditAction(
        form: _form,
        onSucceed: (user) => Navigator.of(context).pop(),
        onFailed: (notice) => Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        )),
      ));
    }
  }

  void _sendVerifyCode() {
    _formKey.currentState.save();

    widget.store.dispatch(accountSendMobileVerifyCodeAction(
      type: 'edit',
      mobile: _form.mobile,
      onSucceed: () => Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('发送成功'),
      )),
      onFailed: (notice) => Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(notice.message),
        duration: notice.duration,
      )),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(WgTheme.paddingSizeNormal),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: '手机号',
                    suffixIcon: IconButton(
                      onPressed: _sendVerifyCode,
                      icon: Icon(Icons.send),
                    ),
                  ),
                  initialValue: _form.mobile,
                  onSaved: (value) => _form.mobile = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: '验证码，6 位数字',
                  ),
                  onSaved: (value) => _form.code = value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
