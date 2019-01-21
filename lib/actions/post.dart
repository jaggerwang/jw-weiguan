import 'dart:io';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:dio/dio.dart';

import '../factory.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'user.dart';

class DeletePostAction {
  final PostEntity post;

  DeletePostAction({
    @required this.post,
  });
}

class PostsPublishedAction {
  final List<PostEntity> posts;
  final int userId;
  final int beforeId;
  final int afterId;
  final bool refresh;

  PostsPublishedAction({
    @required this.posts,
    @required this.userId,
    this.beforeId,
    this.afterId,
    this.refresh = false,
  });
}

class PostsLikedAction {
  final List<PostEntity> posts;
  final int userId;
  final int beforeId;
  final int afterId;
  final bool refresh;

  PostsLikedAction({
    @required this.posts,
    @required this.userId,
    this.beforeId,
    this.afterId,
    this.refresh = false,
  });
}

class LikePostAction {
  final int userId;
  final int postId;

  LikePostAction({
    @required this.userId,
    @required this.postId,
  });
}

class UnlikePostAction {
  final int userId;
  final int postId;

  UnlikePostAction({
    @required this.userId,
    @required this.postId,
  });
}

class PostsFollowingAction {
  final List<PostEntity> posts;
  final int beforeId;
  final int afterId;
  final bool refresh;

  PostsFollowingAction({
    @required this.posts,
    this.beforeId,
    this.afterId,
    this.refresh = false,
  });
}

ThunkAction<AppState> publishPostAction({
  @required PostType type,
  String text,
  List<String> images,
  List<String> videos,
  void Function(int) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();

      final data = FormData.from({
        'type': type.toString().split('.')[1],
        'text': text,
      });
      if (type == PostType.image) {
        for (var i = 0; i < images.length; i++) {
          data['file${i + 1}'] =
              UploadFileInfo(File(images[i]), basename(images[i]));
        }
      } else if (type == PostType.video) {
        for (var i = 0; i < videos.length; i++) {
          data['file${i + 1}'] =
              UploadFileInfo(File(videos[i]), basename(videos[i]));
        }
      }

      final response = await wgService.postForm(
        '/post/create',
        data: data,
      );

      if (response.code == WgApiResponse.codeOk) {
        final id = response.data['id'] as int;
        if (onSucceed != null) onSucceed(id);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> deletePostAction({
  @required PostEntity post,
  void Function() onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.post(
        '/post/delete',
        data: {'id': post.id},
      );

      if (response.code == WgApiResponse.codeOk) {
        store.dispatch(DeletePostAction(post: post));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> postsPublishedAction({
  @required int userId,
  int limit,
  int beforeId,
  int afterId,
  bool refresh = false,
  void Function(List<PostEntity>) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.get(
        '/post/published',
        data: {
          'userId': userId,
          'limit': limit,
          'beforeId': beforeId,
          'afterId': afterId,
        },
      );

      if (response.code == WgApiResponse.codeOk) {
        final users = (response.data['posts'] as List<dynamic>)
            .map<UserEntity>((v) => UserEntity.fromJson(v['creator']))
            .toList();
        store.dispatch(UserInfosAction(users: users));

        final posts = (response.data['posts'] as List<dynamic>)
            .map<PostEntity>((v) => PostEntity.fromJson(v))
            .toList();
        store.dispatch(PostsPublishedAction(
          posts: posts,
          userId: userId,
          beforeId: beforeId,
          afterId: afterId,
          refresh: refresh,
        ));
        if (onSucceed != null) onSucceed(posts);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> postsLikedAction({
  @required int userId,
  int limit,
  int beforeId,
  int afterId,
  bool refresh = false,
  void Function(List<PostEntity>) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.get(
        '/post/liked',
        data: {
          'userId': userId,
          'limit': limit,
          'beforeId': beforeId,
          'afterId': afterId,
        },
      );

      if (response.code == WgApiResponse.codeOk) {
        final users = (response.data['posts'] as List<dynamic>)
            .map<UserEntity>((v) => UserEntity.fromJson(v['creator']))
            .toList();
        store.dispatch(UserInfosAction(users: users));

        final posts = (response.data['posts'] as List<dynamic>)
            .map<PostEntity>((v) => PostEntity.fromJson(v))
            .toList();
        store.dispatch(PostsLikedAction(
          posts: posts,
          userId: userId,
          beforeId: beforeId,
          afterId: afterId,
          refresh: refresh,
        ));
        if (onSucceed != null) onSucceed(posts);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> likePostAction({
  @required int postId,
  void Function() onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.post(
        '/post/like',
        data: {'postId': postId},
      );

      if (response.code == WgApiResponse.codeOk) {
        store.dispatch(LikePostAction(
          userId: store.state.account.user.id,
          postId: postId,
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> unlikePostAction({
  @required int postId,
  void Function() onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.post(
        '/post/unlike',
        data: {'postId': postId},
      );

      if (response.code == WgApiResponse.codeOk) {
        store.dispatch(UnlikePostAction(
          userId: store.state.account.user.id,
          postId: postId,
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> postsFollowingAction({
  int limit,
  int beforeId,
  int afterId,
  bool refresh = false,
  void Function(List<PostEntity>) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
    (Store<AppState> store) async {
      final wgService = await WgFactory().getWgService();
      final response = await wgService.get(
        '/post/following',
        data: {
          'limit': limit,
          'beforeId': beforeId,
          'afterId': afterId,
        },
      );

      if (response.code == WgApiResponse.codeOk) {
        final users = (response.data['posts'] as List<dynamic>)
            .map<UserEntity>((v) => UserEntity.fromJson(v['creator']))
            .toList();
        store.dispatch(UserInfosAction(users: users));

        final posts = (response.data['posts'] as List<dynamic>)
            .map<PostEntity>((v) => PostEntity.fromJson(v))
            .toList();
        store.dispatch(PostsFollowingAction(
          posts: posts,
          beforeId: beforeId,
          afterId: afterId,
          refresh: refresh,
        ));
        if (onSucceed != null) onSucceed(posts);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };
