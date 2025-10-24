import '../../domain/entities/user.dart';

/// User model extending User entity for data layer
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.username,
    super.fullName,
    super.avatar,
    super.role,
    super.status,
    super.referral,
    super.enable2FA,
    super.createdAt,
    super.created,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'],
      fullName: json['fullName'],
      avatar: json['avatar'],
      role: json['role'],
      status: json['status'],
      referral: json['referral'],
      enable2FA: json['enable2FA'],
      createdAt: json['createdAt'],
      created: json['created'],
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'fullName': fullName,
      'avatar': avatar,
      'role': role,
      'status': status,
      'referral': referral,
      'enable2FA': enable2FA,
      'createdAt': createdAt,
      'created': created,
    };
  }

  /// Create UserModel from User entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      username: user.username,
      fullName: user.fullName,
      avatar: user.avatar,
      role: user.role,
      status: user.status,
      referral: user.referral,
      enable2FA: user.enable2FA,
      createdAt: user.createdAt,
      created: user.created,
    );
  }

  /// Convert to User entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      username: username,
      fullName: fullName,
      avatar: avatar,
      role: role,
      status: status,
      referral: referral,
      enable2FA: enable2FA,
      createdAt: createdAt,
      created: created,
    );
  }
}
