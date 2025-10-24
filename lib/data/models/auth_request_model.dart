import 'package:json_annotation/json_annotation.dart';

part 'auth_request_model.g.dart';

/// Authentication request model
@JsonSerializable()
class AuthenticationRequestModel {
  final String credential;
  final String password;

  const AuthenticationRequestModel({
    required this.credential,
    required this.password,
  });

  factory AuthenticationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationRequestModelToJson(this);
}

/// Refresh token request model
@JsonSerializable()
class RefreshTokenRequestModel {
  final String refreshToken;

  const RefreshTokenRequestModel({
    required this.refreshToken,
  });

  factory RefreshTokenRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenRequestModelToJson(this);
}

/// Introspect request model
@JsonSerializable()
class IntrospectRequestModel {
  final String token;

  const IntrospectRequestModel({
    required this.token,
  });

  factory IntrospectRequestModel.fromJson(Map<String, dynamic> json) =>
      _$IntrospectRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$IntrospectRequestModelToJson(this);
}

/// Generic auth code request model
@JsonSerializable()
class GenericAuthCodeRequestModel {
  final String code;

  const GenericAuthCodeRequestModel({
    required this.code,
  });

  factory GenericAuthCodeRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GenericAuthCodeRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$GenericAuthCodeRequestModelToJson(this);
}

/// Forgot password request model
@JsonSerializable()
class ForgotPasswordRequestModel {
  final String email;

  const ForgotPasswordRequestModel({
    required this.email,
  });

  factory ForgotPasswordRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestModelToJson(this);
}
