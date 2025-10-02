import 'package:json_annotation/json_annotation.dart';

part 'auth_request.g.dart';

@JsonSerializable()
class AuthenticationRequest {
  final String credential;
  final String password;

  const AuthenticationRequest({
    required this.credential,
    required this.password,
  });

  factory AuthenticationRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationRequestToJson(this);
}

@JsonSerializable()
class RefreshTokenRequest {
  final String refreshToken;

  const RefreshTokenRequest({
    required this.refreshToken,
  });

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}

@JsonSerializable()
class IntrospectRequest {
  final String token;

  const IntrospectRequest({
    required this.token,
  });

  factory IntrospectRequest.fromJson(Map<String, dynamic> json) =>
      _$IntrospectRequestFromJson(json);

  Map<String, dynamic> toJson() => _$IntrospectRequestToJson(this);
}

@JsonSerializable()
class GenericAuthCodeRequest {
  final String code;

  const GenericAuthCodeRequest({
    required this.code,
  });

  factory GenericAuthCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$GenericAuthCodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GenericAuthCodeRequestToJson(this);
}

@JsonSerializable()
class ForgotPasswordRequest {
  final String email;

  const ForgotPasswordRequest({
    required this.email,
  });

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}
