// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserState _$UserStateFromJson(Map<String, dynamic> json) {
  return UserState(
      users: (json['users'] as Map<String, dynamic>)?.map((k, e) => MapEntry(k,
          e == null ? null : UserEntity.fromJson(e as Map<String, dynamic>))),
      usersFollowing: (json['usersFollowing'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(k, (e as List)?.map((e) => e as int)?.toList())),
      followers: (json['followers'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(k, (e as List)?.map((e) => e as int)?.toList())));
}

Map<String, dynamic> _$UserStateToJson(UserState instance) => <String, dynamic>{
      'users': instance.users,
      'usersFollowing': instance.usersFollowing,
      'followers': instance.followers
    };
