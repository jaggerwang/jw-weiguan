// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostState _$PostStateFromJson(Map<String, dynamic> json) {
  return PostState(
      posts: (json['posts'] as Map<String, dynamic>)?.map((k, e) => MapEntry(k,
          e == null ? null : PostEntity.fromJson(e as Map<String, dynamic>))),
      postsPublished: (json['postsPublished'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(k, (e as List)?.map((e) => e as int)?.toList())),
      postsLiked: (json['postsLiked'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(k, (e as List)?.map((e) => e as int)?.toList())),
      postsFollowing:
          (json['postsFollowing'] as List)?.map((e) => e as int)?.toList());
}

Map<String, dynamic> _$PostStateToJson(PostState instance) => <String, dynamic>{
      'posts': instance.posts,
      'postsPublished': instance.postsPublished,
      'postsLiked': instance.postsLiked,
      'postsFollowing': instance.postsFollowing
    };
