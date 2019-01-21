import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final accountReducer = combineReducers<AccountState>([
  TypedReducer<AccountState, AccountInfoAction>(_accountInfo),
]);

AccountState _accountInfo(AccountState state, AccountInfoAction action) {
  return state.copyWith(
    user: action.user,
  );
}
