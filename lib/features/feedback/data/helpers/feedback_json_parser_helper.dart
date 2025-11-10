import '../models/feedback_model.dart';

List<FeedbackModel> parseFeedbackListJson(List<dynamic> rawList) {
  return rawList
      .whereType<Map<String, dynamic>>()
      .map(FeedbackModel.fromJson)
      .toList();
}
