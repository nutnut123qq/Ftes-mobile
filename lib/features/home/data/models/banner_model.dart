import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/banner.dart';

part 'banner_model.g.dart';

/// Banner model for data layer
@JsonSerializable(explicitToJson: true)
class BannerModel extends Banner {
  const BannerModel({
    super.id,
    super.title,
    super.description,
    super.buttonText,
    super.imageUrl,
    super.url,
    super.backgroundGradient,
    super.backgroundColor,
    super.active,
    super.createdAt,
    super.createdUser,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);

  /// Convert to domain entity
  Banner toEntity() {
    return Banner(
      id: id,
      title: title,
      description: description,
      buttonText: buttonText,
      imageUrl: imageUrl,
      url: url,
      backgroundGradient: backgroundGradient,
      backgroundColor: backgroundColor,
      active: active,
      createdAt: createdAt,
      createdUser: createdUser,
    );
  }

  /// Create from domain entity
  factory BannerModel.fromEntity(Banner banner) {
    return BannerModel(
      id: banner.id,
      title: banner.title,
      description: banner.description,
      buttonText: banner.buttonText,
      imageUrl: banner.imageUrl,
      url: banner.url,
      backgroundGradient: banner.backgroundGradient,
      backgroundColor: banner.backgroundColor,
      active: banner.active,
      createdAt: banner.createdAt,
      createdUser: banner.createdUser,
    );
  }
}
