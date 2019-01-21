import 'package:redux_persist/redux_persist.dart';

import '../models/models.dart';
import '../actions/actions.dart';
import 'account.dart';
import 'publish.dart';
import 'post.dart';
import 'user.dart';

AppState appReducer(AppState state, action) {
  if (action is ResetStateAction) {
    return AppState();
  } else if (action is ResetPublishStateAction) {
    return state.copyWith(
      publish: PublishState(),
    );
  } else if (action is PersistLoadedAction<AppState>) {
    return action.state ?? state;
  } else if (action is PersistErrorAction) {
    print(action.error);
    return AppState();
  } else {
    return state.copyWith(
      account: accountReducer(state.account, action),
      publish: publishReducer(state.publish, action),
      post: postReducer(state.post, action),
      user: userReducer(state.user, action),
    );
  }
}
