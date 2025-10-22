# 📱 Flutter API Integration Guide

## 🎯 Tổng quan

Hướng dẫn này mô tả cách tích hợp API trong Flutter app dựa trên cấu trúc hiện tại đã được test thành công.

## 🏗️ Cấu trúc thư mục



```
lib/
├── main.dart                 # Entry point với Provider setup
├── models/                   # Data models (Request/Response)
│   ├── auth_request.dart     # Authentication request models
│   ├── auth_response.dart    # Authentication response models
│   └── user_request.dart     # User-related request models
├── providers/                # State management
│   └── auth_provider.dart    # Authentication state provider
├── services/                 # API services
│   ├── http_client.dart      # HTTP client wrapper
│   └── auth_service.dart     # Authentication service
├── utils/                    # Utilities
│   ├── api_constants.dart    # API endpoints & constants
│   ├── constants.dart        # App constants
│   └── colors.dart          # Color definitions
├── routes/                   # Navigation
│   └── app_routes.dart      # Route definitions
└── screens/                  # UI screens
    ├── login_screen.dart
    ├── register_screen.dart
    └── create_pin_screen.dart
```

## 🔧 Các thành phần chính

### 1. HTTP Client (`services/http_client.dart`)

**Singleton pattern** để quản lý HTTP requests:

```dart
class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  HttpClient._internal();
  
  // Khởi tạo client
  void initialize() {
    _client = http.Client();
  }
  
  // Token management
  Future<void> setAccessToken(String token) async
  Future<String?> getAccessToken() async
  Future<void> clearTokens() async
  
  // HTTP methods with queryParameters support
  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  })
  
  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    Map<String, dynamic>? queryParameters,
  })
  
  Future<http.Response> put(String endpoint, {...})
  Future<http.Response> delete(String endpoint, {...})
}
```

**Tính năng:**
- ✅ Auto-inject Bearer token vào headers
- ✅ Timeout handling (30s)
- ✅ **Tự động thêm baseUrl** - KHÔNG cần truyền full URL
- ✅ **Support queryParameters** - Tự động convert và append vào URL
- ✅ JSON serialization tự động trong body
- ✅ Persistent token storage (SharedPreferences)

**⚠️ QUAN TRỌNG:**
- HttpClient **tự động thêm baseUrl** vào endpoint
- Chỉ truyền endpoint path (vd: `/api/courses/featured`)
- KHÔNG tự construct full URL bằng `Uri.parse('${baseUrl}${endpoint}')`

### 2. API Constants (`utils/api_constants.dart`)

**Centralized configuration:**

```dart
class ApiConstants {
  static const String baseUrl = 'http://localhost:8081';
  
  // Authentication endpoints
  static const String loginEndpoint = '/api/auth/token';
  static const String verifyEmailCodeEndpoint = '/api/auth/verify-email-code';
  static const String userRegistrationEndpoint = '/api/users/registration';
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
}
```

### 3. Data Models (`models/`)

**JSON serialization với json_annotation:**

```dart
@JsonSerializable()
class UserRegistrationRequest {
  final String email;
  final String password;
  final String username;

  const UserRegistrationRequest({
    required this.email,
    required this.password,
    required this.username,
  });

  factory UserRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$UserRegistrationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserRegistrationRequestToJson(this);
}
```

**Generate code:**
```bash
flutter packages pub run build_runner build
```

### 4. Service Layer (`services/course_service.dart`)

**Business logic cho API calls:**

```dart
class CourseService {
  final HttpClient _http = HttpClient();
  
  CourseService() {
    _http.initialize();
  }
  
  // ✅ ĐÚNG - Sử dụng queryParameters
  Future<List<CourseResponse>> getFeaturedCourses() async {
    final queryParams = {
      'currentPage': 1,
      'pageSize': 100,
    };

    final resp = await _http.get(
      ApiConstants.featuredCoursesEndpoint,
      queryParameters: queryParams,
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      
      // Backend trả về ApiResponse<PagingResponse<GetCourseResponse>>
      if (data is Map && data['result'] != null) {
        final result = data['result'];
        if (result is Map && result['data'] is List) {
          return (result['data'] as List)
              .map((item) => CourseResponse.fromJson(item))
              .toList();
        }
      }
    }

    throw Exception('Failed to load featured courses: ${resp.statusCode}');
  }
  
  // ❌ SAI - Tự construct URL (cần refactor)
  Future<PagingCourseResponse> getAllCourses({
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final queryParams = {
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
    };

    // ❌ KHÔNG nên làm như này
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.coursesEndpoint}')
        .replace(queryParameters: queryParams);
    final resp = await _http.get(uri.toString());
    
    // ✅ NÊN làm như này thay thế
    // final resp = await _http.get(
    //   ApiConstants.coursesEndpoint,
    //   queryParameters: queryParams,
    // );
  }
}
```

### 5. State Management (`providers/course_provider.dart`)

**Provider pattern cho state management:**

```dart
class CourseProvider extends ChangeNotifier {
  final CourseService _courseService = CourseService();
  
  List<CourseResponse> _courses = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;
  
  // Fetch featured courses (non-paginated)
  Future<void> fetchFeaturedCourses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _courses = await _courseService.getFeaturedCourses();
      
      // ⚠️ QUAN TRỌNG: Disable pagination cho non-paginated endpoints
      _currentPage = 1;
      _totalPages = 1;
      _hasMore = false;  // Ngăn load more không cần thiết
      
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load courses: $e';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Fetch with pagination
  Future<void> fetchAllCourses({int page = 1}) async {
    if (_isLoading) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await _courseService.getAllCourses(
        pageNumber: page,
        pageSize: 10,
      );
      
      if (page == 1) {
        _courses = response.courses;
      } else {
        _courses.addAll(response.courses);
      }
      
      _currentPage = page;
      _totalPages = response.totalPages;
      _hasMore = page < _totalPages;
      
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### 6. UI Integration (`screens/`)

**Sử dụng Provider trong UI:**

```dart
class PopularCoursesScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        if (courseProvider.isLoading && courseProvider.courses.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (courseProvider.errorMessage != null) {
          return Center(child: Text(courseProvider.errorMessage!));
        }
        
        return ListView.builder(
          itemCount: courseProvider.courses.length,
          itemBuilder: (context, index) {
            final course = courseProvider.courses[index];
            return CourseCard(course: course);
          },
        );
      },
    );
  }
  
  @override
  void initState() {
    super.initState();
    // Fetch data khi màn hình load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CourseProvider>(context, listen: false)
          .fetchFeaturedCourses();
    });
  }
}
```

## 🚀 Quy trình tích hợp API mới

### Bước 1: Định nghĩa Model

```dart
// models/new_request.dart
@JsonSerializable()
class NewRequest {
  final String field1;
  final int field2;
  
  const NewRequest({
    required this.field1,
    required this.field2,
  });
  
  factory NewRequest.fromJson(Map<String, dynamic> json) =>
      _$NewRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$NewRequestToJson(this);
}
```

### Bước 2: Thêm API Constants

```dart
// utils/api_constants.dart
class ApiConstants {
  // ... existing constants
  
  // New endpoints
  static const String newEndpoint = '/api/new-endpoint';
}
```

### Bước 3: Tạo Service Method

```dart
// services/course_service.dart
class CourseService {
  final HttpClient _http = HttpClient();
  
  CourseService() {
    _http.initialize();
  }
  
  // ✅ ĐÚNG - Pattern được khuyến nghị
  Future<List<CourseResponse>> getFeaturedCourses() async {
    final queryParams = {
      'currentPage': 1,
      'pageSize': 100,
    };

    final resp = await _http.get(
      ApiConstants.featuredCoursesEndpoint,
      queryParameters: queryParams,
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      
      // Parse ApiResponse<PagingResponse<T>> format
      if (data is Map && data['result'] != null) {
        final result = data['result'];
        if (result is Map && result['data'] is List) {
          return (result['data'] as List)
              .map((item) => CourseResponse.fromJson(item))
              .toList();
        }
      }
      
      // Fallback cho format khác
      if (data is List) {
        return data.map((item) => CourseResponse.fromJson(item)).toList();
      }
    }

    throw Exception('Failed to load courses: ${resp.statusCode}');
  }
  
  // POST request với body
  Future<void> enrollCourse(String courseId) async {
    final body = {
      'courseId': courseId,
    };

    final resp = await _http.post(
      ApiConstants.enrollCourseEndpoint,
      body: body,
    );

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Failed to enroll: ${resp.statusCode}');
    }
  }
}
```

**⚠️ Pattern cần TRÁNH:**
```dart
// ❌ KHÔNG nên tự construct full URL
final uri = Uri.parse('${ApiConstants.baseUrl}${endpoint}')
    .replace(queryParameters: queryParams);
final resp = await _http.get(uri.toString());

// ✅ NÊN dùng queryParameters
final resp = await _http.get(endpoint, queryParameters: queryParams);
```

### Bước 4: Tạo hoặc Cập nhật Provider

```dart
// providers/course_provider.dart
class CourseProvider extends ChangeNotifier {
  final CourseService _courseService = CourseService();
  
  List<CourseResponse> _courses = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  List<CourseResponse> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  Future<void> fetchFeaturedCourses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _courses = await _courseService.getFeaturedCourses();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load courses: $e';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### Bước 5: Setup Provider trong main.dart

```dart
// main.dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (context) => CourseProvider()),
        ChangeNotifierProvider(create: (context) => BlogProvider()),
        // Thêm providers khác ở đây
      ],
      child: MaterialApp(
        title: 'Flutter App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
        routes: AppRoutes.routes,
      ),
    );
  }
}
```

### Bước 6: Sử dụng trong UI

```dart
// screens/popular_courses_screen.dart
class PopularCoursesScreen extends StatefulWidget {
  const PopularCoursesScreen({Key? key}) : super(key: key);

  @override
  State<PopularCoursesScreen> createState() => _PopularCoursesScreenState();
}

class _PopularCoursesScreenState extends State<PopularCoursesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data khi màn hình load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CourseProvider>(context, listen: false)
          .fetchFeaturedCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Courses')),
      body: Consumer<CourseProvider>(
        builder: (context, courseProvider, child) {
          // Loading state
          if (courseProvider.isLoading && courseProvider.courses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // Error state
          if (courseProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(courseProvider.errorMessage!),
                  ElevatedButton(
                    onPressed: () => courseProvider.fetchFeaturedCourses(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          // Success state
          return ListView.builder(
            itemCount: courseProvider.courses.length,
            itemBuilder: (context, index) {
              final course = courseProvider.courses[index];
              return CourseCard(course: course);
            },
          );
        },
      ),
    );
  }
}
```

## ⚠️ Lưu ý quan trọng

### 1. URL Construction - QUAN TRỌNG NHẤT

**❌ KHÔNG BAO GIỜ tự construct full URL:**
```dart
// ❌ SAI - Sẽ gây lỗi "Invalid port" hoặc duplicate baseUrl
final uri = Uri.parse('${ApiConstants.baseUrl}${endpoint}')
    .replace(queryParameters: queryParams);
final resp = await _http.get(uri.toString());
```

**✅ LUÔN LUÔN dùng queryParameters:**
```dart
// ✅ ĐÚNG - HttpClient tự động thêm baseUrl
final resp = await _http.get(
  ApiConstants.featuredCoursesEndpoint,  // Chỉ truyền endpoint path
  queryParameters: {'currentPage': 1, 'pageSize': 100},
);
```

**Lý do:**
- `HttpClient.get()` đã tự động thêm `baseUrl` vào endpoint
- Tự construct URL sẽ tạo ra: `http://localhost:8081http://localhost:8081/api/...`
- Gây lỗi "Invalid port" hoặc 404 Not Found

### 2. Response Format Handling

**Backend có 2 loại response format:**

```dart
// Format 1: ApiResponse<PagingResponse<T>>
{
  "success": true,
  "messageDTO": null,
  "result": {
    "data": [...],  // Array of items
    "paging": {...},
    "totalElements": 30,
    "totalPages": 1
  }
}

// Format 2: ApiResponse<T> (single object)
{
  "success": true,
  "messageDTO": null,
  "result": {...}  // Single object
}

// Format 3: Direct array (legacy)
[...]  // Direct array
```

**Parse đúng format:**
```dart
Future<List<CourseResponse>> getFeaturedCourses() async {
  final resp = await _http.get(endpoint, queryParameters: params);
  
  if (resp.statusCode >= 200 && resp.statusCode < 300) {
    final data = jsonDecode(resp.body);
    
    // Check ApiResponse<PagingResponse> format
    if (data is Map && data['result'] != null) {
      final result = data['result'];
      if (result is Map && result['data'] is List) {
        return (result['data'] as List)
            .map((item) => CourseResponse.fromJson(item))
            .toList();
      }
    }
    
    // Fallback: Direct array
    if (data is List) {
      return data.map((item) => CourseResponse.fromJson(item)).toList();
    }
  }
  
  throw Exception('Failed to load: ${resp.statusCode}');
}
```

### 3. Pagination State Management

**Cho non-paginated endpoints, BẮT BUỘC disable pagination:**

```dart
Future<void> fetchFeaturedCourses() async {
  try {
    _courses = await _courseService.getFeaturedCourses();
    
    // ⚠️ QUAN TRỌNG: Disable pagination
    _currentPage = 1;
    _totalPages = 1;
    _hasMore = false;  // Ngăn load more không cần thiết
    
    notifyListeners();
  } catch (e) {
    // Error handling
  }
}
```

**Lý do:**
- Featured/Latest courses trả về tất cả items (không có pagination)
- Nếu không set `_hasMore = false`, UI sẽ cố gắng load more
- Gây ra API calls không cần thiết

### 4. Data Type Mapping

**Backend expects specific types - CHÚ Ý type conversion:**
```dart
// ❌ Wrong - Backend expects Integer
body: {
  'email': email,
  'code': code,  // String "123456"
}

// ✅ Correct - Backend expects Integer
final intCode = int.parse(code);  // Convert to int
body: {
  'email': email,
  'otp': intCode,  // Integer 123456
}
```

### 5. Error Handling

**Comprehensive error handling:**
```dart
try {
  final response = await _http.post(endpoint, body: data);
  
  if (response.statusCode >= 200 && response.statusCode < 300) {
    // Success
    final data = jsonDecode(response.body);
    return DataModel.fromJson(data);
  } else {
    // Handle specific error codes
    if (response.statusCode == 400) {
      throw Exception('Bad Request: ${response.body}');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized - Please login again');
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    }
    throw Exception('HTTP ${response.statusCode}: ${response.body}');
  }
} on HttpException catch (e) {
  print('HTTP Error: $e');
  throw Exception('Network error: $e');
} on FormatException catch (e) {
  print('JSON Parse Error: $e');
  throw Exception('Invalid response format');
} catch (e) {
  print('Unexpected Error: $e');
  throw Exception('API call failed: $e');
}
```

### 6. Debug Logging

**Add debug logs for troubleshooting:**
```dart
Future<void> apiCall() async {
  print('=== DEBUG: Calling ${ApiConstants.endpoint} ===');
  print('Query params: $queryParams');
  print('Request body: $requestBody');
  
  final response = await _http.post(endpoint, body: requestBody);
  
  print('=== Response status: ${response.statusCode} ===');
  print('=== Response body: ${response.body} ===');
  
  if (response.statusCode >= 200 && response.statusCode < 300) {
    print('✅ API call successful');
  } else {
    print('❌ API call failed');
  }
}
```

### 7. Token Management

**Automatic token injection - KHÔNG cần manual setup:**
```dart
// ❌ KHÔNG cần làm thế này
final headers = {
  'Authorization': 'Bearer $token',
  'Content-Type': 'application/json',
};
final resp = await http.get(url, headers: headers);

// ✅ HttpClient tự động inject token
final resp = await _http.get(endpoint);
// Token tự động được thêm vào header nếu đã login
```

## 🎯 Best Practices

### 1. Always use queryParameters
```dart
// ✅ ĐÚNG
final resp = await _http.get(endpoint, queryParameters: {'page': 1});

// ❌ SAI
final uri = Uri.parse('${baseUrl}${endpoint}?page=1');
final resp = await _http.get(uri.toString());
```

### 2. Use models cho request/response
- Tạo model classes với `@JsonSerializable()`
- Generate code với `build_runner`
- Type-safe và dễ maintain

### 3. Centralize API constants
- Tất cả endpoints trong `api_constants.dart`
- Dễ dàng update khi backend thay đổi
- Tránh hardcode URL trong code

### 4. Handle loading states properly
```dart
// Show loading khi đang fetch
if (provider.isLoading && provider.data.isEmpty) {
  return CircularProgressIndicator();
}

// Show error với retry button
if (provider.errorMessage != null) {
  return ErrorWidget(onRetry: () => provider.fetchData());
}
```

### 5. Show meaningful error messages
- Parse error response từ backend
- Hiển thị message user-friendly
- Log chi tiết error cho debugging

### 6. Add debug logs cho development
- Log request parameters
- Log response status & body
- Giúp troubleshoot nhanh hơn

### 7. Use Provider pattern correctly
- Provider ở top level (main.dart)
- Use `Consumer` cho rebuild widget
- Use `Provider.of(context, listen: false)` cho actions

### 8. Validate data types trước khi gửi API
- Check null values
- Convert types nếu cần (String → int)
- Validate format (email, phone, etc.)

### 9. Handle network timeouts
- HttpClient đã set timeout 30s
- Catch `TimeoutException` riêng
- Show appropriate error message

### 10. Disable pagination cho non-paginated APIs
```dart
// Featured courses không có pagination
_hasMore = false;  // QUAN TRỌNG
_currentPage = 1;
_totalPages = 1;
```

### 11. KHÔNG tự construct URL
- Luôn dùng `_http.get(endpoint, queryParameters: ...)`
- HttpClient tự động thêm baseUrl
- Tránh lỗi duplicate baseUrl

### 12. Parse response format correctly
- Check `data['result']['data']` cho PagingResponse
- Check `data['result']` cho single object
- Fallback cho direct array (legacy)

## 🔄 Common Issues & Solutions

### Issue 1: "Invalid port" Error
**Nguyên nhân:** Tự construct URL gây duplicate baseUrl
```
http://localhost:8081http://localhost:8081/api/courses
```

**Giải pháp:**
```dart
// ❌ SAI
final uri = Uri.parse('${ApiConstants.baseUrl}${endpoint}');
final resp = await _http.get(uri.toString());

// ✅ ĐÚNG
final resp = await _http.get(endpoint, queryParameters: params);
```

### Issue 2: "Page index must not be less than zero"
**Nguyên nhân:** Backend pagination bắt đầu từ 0, Flutter gửi currentPage=0

**Giải pháp:**
```dart
// ✅ Luôn gửi currentPage từ 1 trở lên
final queryParams = {
  'currentPage': 1,  // Không bao giờ gửi 0
  'pageSize': 100,
};
```

### Issue 3: Pagination không tắt cho Featured Courses
**Nguyên nhân:** Quên set `_hasMore = false`

**Giải pháp:**
```dart
Future<void> fetchFeaturedCourses() async {
  _courses = await _courseService.getFeaturedCourses();
  
  // ⚠️ BẮT BUỘC cho non-paginated endpoints
  _hasMore = false;
  _currentPage = 1;
  _totalPages = 1;
}
```

### Issue 4: Cannot parse JSON response
**Nguyên nhân:** Backend response format khác expected

**Giải pháp:**
```dart
// Handle multiple response formats
if (data is Map && data['result'] != null) {
  final result = data['result'];
  
  // PagingResponse format
  if (result is Map && result['data'] is List) {
    return (result['data'] as List).map(...).toList();
  }
  
  // Single object format
  if (result is Map) {
    return Model.fromJson(result);
  }
}

// Fallback: Direct array
if (data is List) {
  return data.map(...).toList();
}
```

### Issue 5: Token not being sent
**Nguyên nhân:** Chưa login hoặc token bị clear

**Kiểm tra:**
```dart
final token = await HttpClient().getAccessToken();
print('Current token: $token');

// Nếu null, cần login lại
if (token == null) {
  // Redirect to login
}
```

### Issue 6: Inconsistent API patterns trong codebase
**Nguyên nhân:** Một số methods dùng cách cũ, một số dùng cách mới

**Giải pháp:**
- Refactor tất cả methods theo pattern mới (queryParameters)
- Reference: `getFeaturedCourses()` là pattern đúng
- Cần refactor: `getAllCourses()`, `searchCourses()`, `checkEnrollment()`

## 📝 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  http: ^1.1.0
  shared_preferences: ^2.2.2
  json_annotation: ^4.8.1
  google_sign_in: ^6.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.7
  json_serializable: ^6.7.1
```

---

**💡 Tip:** Luôn test API integration với debug logs để dễ dàng troubleshoot khi có vấn đề!
