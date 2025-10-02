import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthenticationResponse {
  final String accessToken;
  final String refreshToken;
  final String? tokenType;
  final int? expiresIn;
  final bool? authenticated;
  final String? deviceId;
  final UserInfo? user;

  const AuthenticationResponse({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType,
    this.expiresIn,
    this.authenticated,
    this.deviceId,
    this.user,
  });

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationResponseToJson(this);
}

@JsonSerializable()
class UserInfo {
  final String id;
  final String email;
  final String? username;
  final String? fullName;
  final String? avatar;
  final String? role;
  final String? status;
  final bool? referral;
  final bool? enable2FA;
  final String? createdAt;
  final String? created;

  const UserInfo({
    required this.id,
    required this.email,
    this.username,
    this.fullName,
    this.avatar,
    this.role,
    this.status,
    this.referral,
    this.enable2FA,
    this.createdAt,
    this.created,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

@JsonSerializable()
class IntrospectResponse {
  final bool valid;
  final String? userId;
  final String? email;
  final String? role;
  final DateTime? expiresAt;

  const IntrospectResponse({
    required this.valid,
    this.userId,
    this.email,
    this.role,
    this.expiresAt,
  });

  factory IntrospectResponse.fromJson(Map<String, dynamic> json) =>
      _$IntrospectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IntrospectResponseToJson(this);
}

@JsonSerializable()
class TwoFAResponse {
  final String secretKey;
  final String qrCodeUrl;

  const TwoFAResponse({
    required this.secretKey,
    required this.qrCodeUrl,
  });

  factory TwoFAResponse.fromJson(Map<String, dynamic> json) =>
      _$TwoFAResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TwoFAResponseToJson(this);
}

@JsonSerializable()
class VerifyMailOTPResponse {
  final bool success;
  final String? message;
  final String? userId;

  const VerifyMailOTPResponse({
    required this.success,
    this.message,
    this.userId,
  });

  factory VerifyMailOTPResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyMailOTPResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyMailOTPResponseToJson(this);
}

@JsonSerializable()
class ApiResponse<T> {
  final T? result;
  final MessageDTO? messageDTO;
  final bool success;

  const ApiResponse({
    this.result,
    this.messageDTO,
    required this.success,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

@JsonSerializable()
class MessageDTO {
  final String? code;
  final String? message;

  const MessageDTO({
    this.code,
    this.message,
  });

  factory MessageDTO.fromJson(Map<String, dynamic> json) =>
      _$MessageDTOFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDTOToJson(this);
}
