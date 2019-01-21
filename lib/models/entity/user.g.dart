// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) {
  return UserEntity(
      id: json['id'] as int,
      username: json['username'] as String,
      intro: json['intro'] as String,
      avatar: json['avatar'] as String,
      mobile: json['mobile'] as String,
      email: json['email'] as String,
      postCount: json['postCount'] as int,
      likeCount: json['likeCount'] as int,
      followingCount: json['followingCount'] as int,
      isFollowing: json['isFollowing'] as bool,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String));
}

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'intro': instance.intro,
      'avatar': instance.avatar,
      'mobile': instance.mobile,
      'email': instance.email,
      'postCount': instance.postCount,
      'likeCount': instance.likeCount,
      'followingCount': instance.followingCount,
      'isFollowing': instance.isFollowing,
      'createdAt': instance.createdAt?.toIso8601String()
    };
