import 'package:json_annotation/json_annotation.dart';

part 'upload_image_response_model.g.dart';

/// Upload image response model
@JsonSerializable(explicitToJson: true)
class UploadImageResponseModel {
  final bool success;
  final UploadImageResultModel? result;

  const UploadImageResponseModel({
    required this.success,
    this.result,
  });

  factory UploadImageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UploadImageResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadImageResponseModelToJson(this);
}

/// Upload image result model
@JsonSerializable(explicitToJson: true)
class UploadImageResultModel {
  final String cdnUrl;
  final String url;
  final String message;

  const UploadImageResultModel({
    required this.cdnUrl,
    required this.url,
    required this.message,
  });

  factory UploadImageResultModel.fromJson(Map<String, dynamic> json) =>
      _$UploadImageResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadImageResultModelToJson(this);
}

