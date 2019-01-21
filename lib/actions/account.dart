import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../factory.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'reset.dart';

class AccountInfoAction {
  final UserEntity user;

  AccountInfoAction({
    @required this.user,
  });
}

ThunkAction<AppState> accountRegisterAction({
  @required RegisterForm form,
  void Function(UserEntity) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.post(
        '/account/register',
        data: form.toJson(),
      );

      if (response.code == WgApiResponse.codeOk) {
        final user = UserEntity.fromJson(response.data['user']);
        if (onSucceed != null) onSucceed(user);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> accountLoginAction({
  @required LoginForm form,
  void Function(UserEntity) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.post(
        '/account/login',
        data: form.toJson(),
      );

      if (response.code == WgApiResponse.codeOk) {
        final user = UserEntity.fromJson(response.data['user']);
        store.dispatch(AccountInfoAction(user: user));
        if (onSucceed != null) onSucceed(user);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> accountLogoutAction({
  void Function() onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.get('/account/logout');

      if (response.code == WgApiResponse.codeOk) {
        store.dispatch(ResetStateAction());
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> accountInfoAction({
  void Function(UserEntity) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.get('/account/info');

      if (response.code == WgApiResponse.codeOk) {
        final user = UserEntity.fromJson(response.data['user']);
        store.dispatch(AccountInfoAction(user: user));
        if (onSucceed != null) onSucceed(user);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> accountEditAction({
  @required ProfileForm form,
  void Function(UserEntity) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.post(
        '/account/edit',
        data: form.toJson(),
      );

      if (response.code == WgApiResponse.codeOk) {
        final user = UserEntity.fromJson(response.data['user']);
        store.dispatch(accountInfoAction());
        if (onSucceed != null) onSucceed(user);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> accountSendMobileVerifyCodeAction({
  @required String mobile,
  void Function() onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.post(
        '/account/send/mobile/verify/code',
        data: {'mobile': mobile},
      );

      if (response.code == WgApiResponse.codeOk) {
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };
