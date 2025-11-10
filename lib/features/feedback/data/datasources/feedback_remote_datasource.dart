import '../models/create_feedback_request_model.dart';
import '../models/feedback_model.dart';
import '../models/paginated_feedback_model.dart';
import '../models/update_feedback_request_model.dart';

abstract class FeedbackRemoteDataSource {
  Future<PaginatedFeedbackModel> getFeedbacksByCourse({
    required int courseId,
    int page,
    int size,
  });

  Future<FeedbackModel> createFeedback(CreateFeedbackRequestModel request);

  Future<FeedbackModel> updateFeedback(
    int feedbackId,
    UpdateFeedbackRequestModel request,
  );

  Future<void> deleteFeedback(int feedbackId);
}
