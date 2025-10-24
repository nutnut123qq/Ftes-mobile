import 'package:json_annotation/json_annotation.dart';

part 'auth_response_model.g.dart';

/// Authentication response model
@JsonSerializable()
class AuthenticationResponseModel {
  final String accessToken;
  final String refreshToken;
  final bool? authenticated;
  final String? deviceId;

  const AuthenticationResponseModel({
    required this.accessToken,
    required this.refreshToken,
    this.authenticated,
    this.deviceId,
  });

  factory AuthenticationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationResponseModelToJson(this);
}

/// Introspect response model
@JsonSerializable()
class IntrospectResponseModel {
  final bool valid;
  final String? userId;
  final String? email;
  final String? role;
  final DateTime? expiresAt;

  const IntrospectResponseModel({
    required this.valid,
    this.userId,
    this.email,
    this.role,
    this.expiresAt,
  });

  factory IntrospectResponseModel.fromJson(Map<String, dynamic> json) =>
      _$IntrospectResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$IntrospectResponseModelToJson(this);
}

/// Two-factor authentication response model
@JsonSerializable()
class TwoFAResponseModel {
  final String secretKey;
  final String qrCodeUrl;

  const TwoFAResponseModel({
    required this.secretKey,
    required this.qrCodeUrl,
  });

  factory TwoFAResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TwoFAResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TwoFAResponseModelToJson(this);
}

/// Verify mail OTP response model
@JsonSerializable()
class VerifyMailOTPResponseModel {
  final bool success;
  final String? message;
  final String? userId;

  const VerifyMailOTPResponseModel({
    required this.success,
    this.message,
    this.userId,
  });

  factory VerifyMailOTPResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyMailOTPResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyMailOTPResponseModelToJson(this);
}

/// Generic API response model
@JsonSerializable(genericArgumentFactories: true)
class ApiResponseModel<T> {
  final T? result;
  final MessageDTOModel? messageDTO;
  final bool success;

  const ApiResponseModel({
    this.result,
    this.messageDTO,
    required this.success,
  });

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseModelFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseModelToJson(this, toJsonT);
}

/// Message DTO model
@JsonSerializable()
class MessageDTOModel {
  final String? code;
  final String? message;

  const MessageDTOModel({
    this.code,
    this.message,
  });

  factory MessageDTOModel.fromJson(Map<String, dynamic> json) =>
      _$MessageDTOModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDTOModelToJson(this);
}