/// Constants for Roadmap feature
class RoadmapConstants {
  // Error Messages
  static const String errorGeneratingRoadmap = 'Lỗi khi tạo roadmap';
  static const String errorNoInternet = 'Không có kết nối internet';
  static const String errorServerError = 'Lỗi máy chủ, vui lòng thử lại sau';
  static const String errorInvalidData = 'Dữ liệu không hợp lệ';
  static const String errorTimeout = 'Yêu cầu quá thời gian chờ, vui lòng thử lại';
  
  // Loading Messages
  static const String generatingRoadmap = 'Đang tạo lộ trình học tập...';
  static const String loadingSkills = 'Đang tải danh sách kỹ năng...';
  
  // Success Messages
  static const String roadmapGeneratedSuccess = 'Đã tạo lộ trình thành công';
  
  // Empty States
  static const String noSkillsAvailable = 'Không có kỹ năng nào';
  static const String noRoadmapGenerated = 'Chưa tạo lộ trình';
  
  // Default Values
  static const int defaultTerm = 1;
  static const int computeThreshold = 20; // Use compute isolate when skills > 20 items
  static const int maxRetries = 3;
  
  // UI Text
  static const String roadmapTitle = 'Lộ Trình Cá Nhân Hóa';
  static const String specializationLabel = 'Chuyên ngành';
  static const String currentSkillsLabel = 'Kỹ năng hiện có';
  static const String termLabel = 'Học kỳ';
  static const String generateButtonLabel = 'Tạo Lộ Trình Ngay';
  static const String retryLabel = 'Thử lại';
  static const String viewCourseLabel = 'Xem khóa học';
  
  // Specialization Mapping
  static const Map<String, String> specializationMap = {
    'javaDeep': 'Java chuyên sâu',
    'feDev': 'Frontend Development',
    'beDev': 'Backend Development',
    'fullStack': 'Full-stack Development',
    'mobileDev': 'Mobile Development',
    'dataScience': 'Data Science',
    'mlDev': 'Machine Learning',
    'devOps': 'DevOps',
    'cloudComp': 'Cloud Computing',
  };
  
  // Helper method to get specialization string from enum value
  static String getSpecializationString(String enumValue) {
    return specializationMap[enumValue] ?? 'Unknown Specialization';
  }
}
