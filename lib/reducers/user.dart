import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final userReducer = combineReducers<UserState>([
  TypedReducer<UserState, UserInfoAction>(_userInfo),
  TypedReducer<UserState, UserInfosAction>(_userInfos),
  TypedReducer<UserState, UsersFollowingAction>(_usersFollowing),
  TypedReducer<UserState, FollowersAction>(_followers),
  TypedReducer<UserState, FollowUserAction>(_followUser),
  TypedReducer<UserState, UnfollowUserAction>(_unfollowUser),
]);

UserState _userInfo(UserState state, UserInfoAction action) {
  var userId = action.user.id.toString();

  var users = Map<String, UserEntity>.from(state.users);
  users[userId] = action.user;

  return state.copyWith(
    users: users,
  );
}

UserState _userInfos(UserState state, UserInfosAction action) {
  var users = Map<String, UserEntity>.from(state.users);
  users.addAll(Map.fromIterable(
    action.users,
    key: (v) => (v as UserEntity).id.toString(),
    value: (v) => v,
  ));

  return state.copyWith(
    users: users,
  );
}

UserState _usersFollowing(UserState state, UsersFollowingAction action) {
  var userId = action.userId.toString();

  var users = Map<String, UserEntity>.from(state.users);
  users.addAll(Map.fromIterable(
    action.users,
    key: (v) => (v as UserEntity).id.toString(),
    value: (v) => v,
  ));

  var usersFollowing = Map<String, List<int>>.from(state.usersFollowing);
  usersFollowing[userId] = usersFollowing[userId] ?? [];
  final userIds = action.users.map<int>((v) => v.id).toList();
  if (action.refresh) {
    usersFollowing[userId] = userIds;
  } else if (action.offset == null) {
    usersFollowing[userId].insertAll(
      0,
      userIds.where((v) => !usersFollowing[userId].contains(v)),
    );
  } else {
    usersFollowing[userId].addAll(userIds);
  }

  return state.copyWith(
    users: users,
    usersFollowing: usersFollowing,
  );
}

UserState _followers(UserState state, FollowersAction action) {
  var userId = action.userId.toString();

  var users = Map<String, UserEntity>.from(state.users);
  users.addAll(Map.fromIterable(action.users,
      key: (v) => (v as UserEntity).id.toString(), value: (v) => v));

  var followers = Map<String, List<int>>.from(state.followers);
  followers[userId] = followers[userId] ?? [];
  final userIds = action.users.map<int>((v) => v.id).toList();
  if (action.refresh) {
    followers[userId] = userIds;
  } else if (action.offset == null) {
    followers[userId].insertAll(
      0,
      userIds.where((v) => !followers[userId].contains(v)),
    );
  } else {
    followers[userId].addAll(userIds);
  }

  return state.copyWith(
    users: users,
    followers: followers,
  );
}

UserState _followUser(UserState state, FollowUserAction action) {
  var userId = action.userId.toString();
  var followingId = action.followingId.toString();

  var users = Map<String, UserEntity>.from(state.users);
  users[followingId] = users[followingId].copyWith(isFollowing: true);

  var usersFollowing = Map<String, List<int>>.from(state.usersFollowing);
  usersFollowing[userId] = usersFollowing[userId] ?? [];
  usersFollowing[userId]
    ..remove(action.followingId)
    ..insert(0, action.followingId);

  return state.copyWith(
    users: users,
    usersFollowing: usersFollowing,
  );
}

UserState _unfollowUser(UserState state, UnfollowUserAction action) {
  var userId = action.userId.toString();
  var followingId = action.followingId.toString();

  var users = Map<String, UserEntity>.from(state.users);
  users[followingId] = users[followingId].copyWith(isFollowing: false);

  var usersFollowing = Map<String, List<int>>.from(state.usersFollowing);
  usersFollowing[userId] = usersFollowing[userId] ?? [];
  usersFollowing[userId].remove(action.followingId);

  return state.copyWith(
    users: users,
    usersFollowing: usersFollowing,
  );
}
