/// Profile feature constants
class ProfileConstants {
  // API Endpoints
  static const String getProfileByIdEndpoint = '/api/profiles/view';
  static const String getProfileByUsernameEndpoint = '/api/profiles/detail';
  static const String getInstructorCoursesEndpoint = '/api/courses/creator';
  static const String createProfileEndpoint = '/api/profiles';
  static const String updateProfileEndpoint = '/api/profiles';
  static const String createProfileAutoEndpoint = '/api/profiles/create';
  static const String countParticipantsEndpoint = '/api/profiles/count-participants';
  static const String checkApplyCourseEndpoint = '/api/profiles';
  static const String uploadImageEndpoint = '/api/github/upload-image';

  // Error Messages
  static const String errorProfileNotFound = 'Profile not found';
  static const String errorCreateProfileFailed = 'Failed to create profile';
  static const String errorUpdateProfileFailed = 'Failed to update profile';
  static const String errorUploadImageFailed = 'Failed to upload image';
  static const String errorGetProfileFailed = 'Failed to get profile';
  static const String errorGetInstructorCoursesFailed = 'Failed to get instructor courses';
  static const String errorCountParticipantsFailed = 'Failed to count participants';
  static const String errorCheckApplyCourseFailed = 'Failed to check course application';

  // Success Messages
  static const String successProfileCreated = 'Profile created successfully';
  static const String successProfileUpdated = 'Profile updated successfully';
  static const String successImageUploaded = 'Image uploaded successfully';

  // Default Values
  static const String defaultAvatar = 'https://via.placeholder.com/150';
  static const String defaultDescription = '';
  static const String defaultJobName = '';
  static const String defaultGender = 'other';
  static const String defaultDataOfBirth = '';
  static const String defaultFacebook = '';
  static const String defaultTwitter = '';
  static const String defaultYoutube = '';
  static const String defaultRole = 'student';
  static const String defaultContentCourse = '';

  // Performance Thresholds
  static const int instructorCoursesThreshold = 20; // Use compute isolate if > 20 courses
  static const int maxCoursesDisplay = 100; // Limit display courses

  // Validation
  static const int maxNameLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxJobNameLength = 100;
  static const int maxSocialUrlLength = 200;
}

