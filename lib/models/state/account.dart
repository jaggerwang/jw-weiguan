import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import '../entity/user.dart';

part 'account.g.dart';

@JsonSerializable()
@immutable
class AccountState {
  final UserEntity user;

  AccountState({
    UserEntity user,
  }) : this.user = user ?? UserEntity();

  factory AccountState.fromJson(Map<String, dynamic> json) =>
      _$AccountStateFromJson(json);

  Map<String, dynamic> toJson() => _$AccountStateToJson(this);

  AccountState copyWith({
    UserEntity user,
  }) =>
      AccountState(
        user: user ?? this.user,
      );
}
