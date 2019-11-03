import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../factory.dart';
import '../models/models.dart';
import '../services/services.dart';

class UserInfoAction {
  final UserEntity user;

  UserInfoAction({
    @required this.user,
  });
}

class UserInfosAction {
  final List<UserEntity> users;

  UserInfosAction({
    @required this.users,
  });
}

class UsersFollowingAction {
  final List<UserEntity> users;
  final int userId;
  final int offset;
  final bool refresh;

  UsersFollowingAction({
    @required this.users,
    @required this.userId,
    this.offset,
    this.refresh = false,
  });
}

class FollowersAction {
  final List<UserEntity> users;
  final int userId;
  final int offset;
  final bool refresh;

  FollowersAction({
    @required this.users,
    @required this.userId,
    this.offset,
    this.refresh = false,
  });
}

class FollowUserAction {
  final int followerId;
  final int followingId;

  FollowUserAction({
    @required this.followerId,
    @required this.followingId,
  });
}

class UnfollowUserAction {
  final int followerId;
  final int followingId;

  UnfollowUserAction({
    @required this.followerId,
    @required this.followingId,
  });
}

ThunkAction<AppState> userInfoAction({
  @required int id,
  void Function(UserEntity) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.get(
        '/user/info',
        data: {'id': id},
      );

      if (response.code == WgApiResponse.codeOk) {
        final user = UserEntity.fromJson(response.data['user']);
        store.dispatch(UserInfoAction(user: user));
        if (onSucceed != null) onSucceed(user);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> usersFollowingAction({
  @required int userId,
  int limit,
  int offset,
  bool refresh = false,
  void Function(List<UserEntity>) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.get(
        '/user/followings',
        data: {
          'userId': userId,
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.code == WgApiResponse.codeOk) {
        final users = (response.data['users'] as List<dynamic>)
            .map((value) => UserEntity.fromJson(value))
            .toList();
        store.dispatch(UsersFollowingAction(
          users: users,
          userId: userId,
          offset: offset,
          refresh: refresh,
        ));
        if (onSucceed != null) onSucceed(users);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> followersAction({
  @required int userId,
  int limit,
  int offset,
  bool refresh = false,
  void Function(List<UserEntity>) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.get(
        '/user/followers',
        data: {
          'userId': userId,
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.code == WgApiResponse.codeOk) {
        final users = (response.data['users'] as List<dynamic>)
            .map((value) => UserEntity.fromJson(value))
            .toList();
        store.dispatch(FollowersAction(
          users: users,
          userId: userId,
          offset: offset,
          refresh: refresh,
        ));
        if (onSucceed != null) onSucceed(users);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> followUserAction({
  @required int followingId,
  void Function() onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.post(
        '/user/follow',
        data: {'followingId': followingId},
      );

      if (response.code == WgApiResponse.codeOk) {
        store.dispatch(FollowUserAction(
          followerId: store.state.account.user.id,
          followingId: followingId,
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> unfollowUserAction({
  @required int followingId,
  void Function() onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.post(
        '/user/unfollow',
        data: {'followingId': followingId},
      );

      if (response.code == WgApiResponse.codeOk) {
        store.dispatch(UnfollowUserAction(
          followerId: store.state.account.user.id,
          followingId: followingId,
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };
