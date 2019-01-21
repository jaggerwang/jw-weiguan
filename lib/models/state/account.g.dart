// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountState _$AccountStateFromJson(Map<String, dynamic> json) {
  return AccountState(
      user: json['user'] == null
          ? null
          : UserEntity.fromJson(json['user'] as Map<String, dynamic>));
}

Map<String, dynamic> _$AccountStateToJson(AccountState instance) =>
    <String, dynamic>{'user': instance.user};
