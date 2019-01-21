import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import '../entity/post.dart';

part 'post.g.dart';

@JsonSerializable()
@immutable
class PostState {
  final Map<String, PostEntity> posts;
  final Map<String, List<int>> postsPublished;
  final Map<String, List<int>> postsLiked;
  final List<int> postsFollowing;

  PostState({
    this.posts = const {},
    this.postsPublished = const {},
    this.postsLiked = const {},
    this.postsFollowing = const [],
  });

  factory PostState.fromJson(Map<String, dynamic> json) =>
      _$PostStateFromJson(json);

  Map<String, dynamic> toJson() => _$PostStateToJson(this);

  PostState copyWith({
    Map<String, PostEntity> posts,
    Map<String, List<int>> postsPublished,
    Map<String, List<int>> postsLiked,
    List<int> postsFollowing,
  }) =>
      PostState(
        posts: posts ?? this.posts,
        postsPublished: postsPublished ?? this.postsPublished,
        postsLiked: postsLiked ?? this.postsLiked,
        postsFollowing: postsFollowing ?? this.postsFollowing,
      );
}
