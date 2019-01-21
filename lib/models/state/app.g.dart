// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) {
  return AppState(
      version: json['version'] as String,
      account: json['account'] == null
          ? null
          : AccountState.fromJson(json['account'] as Map<String, dynamic>),
      post: json['post'] == null
          ? null
          : PostState.fromJson(json['post'] as Map<String, dynamic>),
      publish: json['publish'] == null
          ? null
          : PublishState.fromJson(json['publish'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : UserState.fromJson(json['user'] as Map<String, dynamic>));
}

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'version': instance.version,
      'account': instance.account,
      'post': instance.post,
      'publish': instance.publish,
      'user': instance.user
    };
