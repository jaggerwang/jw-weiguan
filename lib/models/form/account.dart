import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class RegisterForm {
  String username;
  String password;

  RegisterForm({
    this.username = '',
    this.password = '',
  });

  factory RegisterForm.fromJson(Map<String, dynamic> json) =>
      _$RegisterFormFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterFormToJson(this);
}

@JsonSerializable()
class LoginForm {
  String username;
  String password;

  LoginForm({
    this.username = '',
    this.password = '',
  });

  factory LoginForm.fromJson(Map<String, dynamic> json) =>
      _$LoginFormFromJson(json);

  Map<String, dynamic> toJson() => _$LoginFormToJson(this);
}

@JsonSerializable()
class ProfileForm {
  String username;
  String password;
  String avatar;
  String mobile;
  String email;
  String code;

  ProfileForm({
    this.username,
    this.password,
    this.avatar,
    this.mobile,
    this.email,
    this.code,
  });

  factory ProfileForm.fromJson(Map<String, dynamic> json) =>
      _$ProfileFormFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileFormToJson(this);
}
