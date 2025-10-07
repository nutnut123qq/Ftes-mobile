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
  
  // Token management
  Future<void> setAccessToken(String token) async
  Future<String?> getAccessToken() async
  Future<void> clearTokens() async
  
  // HTTP methods
  Future<http.Response> get(String endpoint, {...})
  Future<http.Response> post(String endpoint, {...})
  Future<http.Response> put(String endpoint, {...})
  Future<http.Response> delete(String endpoint, {...})
}
```

**Tính năng:**
- ✅ Auto-inject Bearer token vào headers
- ✅ Timeout handling (30s)
- ✅ JSON serialization/deserialization
- ✅ Persistent token storage (SharedPreferences)

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

### 4. Service Layer (`services/auth_service.dart`)

**Business logic cho API calls:**

```dart
class AuthService {
  final HttpClient _httpClient = HttpClient();
  
  // Registration
  Future<void> register(UserRegistrationRequest request) async {
    final response = await _httpClient.post(
      ApiConstants.userRegistrationEndpoint,
      body: request.toJson(),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Registration failed: ${response.statusCode}');
    }
  }
  
  // Email verification
  Future<void> verifyEmailOTP(String email, String code) async {
    final intCode = int.tryParse(code);
    if (intCode == null) {
      throw Exception('Invalid OTP format: $code');
    }
    
    final response = await _httpClient.post(
      ApiConstants.verifyEmailCodeEndpoint,
      body: {
        'email': email,
        'otp': intCode,  // Backend expects Integer
      },
    );
    
    if (response.statusCode != 200) {
      throw Exception('Email verification failed: ${response.statusCode}');
    }
  }
}
```

### 5. State Management (`providers/auth_provider.dart`)

**Provider pattern cho state management:**

```dart
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserInfo? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;
  
  // Registration
  Future<bool> register({
    required String email,
    required String password,
    required String username,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final request = UserRegistrationRequest(
        email: email,
        password: password,
        username: username,
      );
      
      await _authService.register(request);
      return true;
    } catch (e) {
      _setError('Đăng ký thất bại: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
```

### 6. UI Integration (`screens/`)

**Sử dụng Provider trong UI:**

```dart
class RegisterScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return ElevatedButton(
          onPressed: authProvider.isLoading ? null : _signUp,
          child: authProvider.isLoading 
            ? CircularProgressIndicator()
            : Text('Đăng ký'),
        );
      },
    );
  }
  
  Future<void> _signUp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.register(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
    );
    
    if (success) {
      Navigator.pushNamed(context, AppConstants.routeCreatePin);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'Lỗi không xác định')),
      );
    }
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
// services/new_service.dart
class NewService {
  final HttpClient _httpClient = HttpClient();
  
  Future<NewResponse> callNewAPI(NewRequest request) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.newEndpoint,
        body: request.toJson(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return NewResponse.fromJson(data['result']);
      } else {
        throw Exception('API call failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('New service error: $e');
    }
  }
}
```

### Bước 4: Tạo Provider

```dart
// providers/new_provider.dart
class NewProvider extends ChangeNotifier {
  final NewService _newService = NewService();
  
  bool _isLoading = false;
  String? _errorMessage;
  NewData? _data;
  
  Future<bool> callNewAPI(String field1, int field2) async {
    _setLoading(true);
    _clearError();
    
    try {
      final request = NewRequest(field1: field1, field2: field2);
      _data = await _newService.callNewAPI(request);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('API call failed: $e');
      return false;
    } finally {
      _setLoading(false);
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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (context) => NewProvider()),
      ],
      child: MaterialApp(
        // ... app configuration
      ),
    );
  }
}
```

### Bước 6: Sử dụng trong UI

```dart
// screens/new_screen.dart
class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewProvider>(
      builder: (context, newProvider, child) {
        return ElevatedButton(
          onPressed: newProvider.isLoading ? null : () => _callAPI(context),
          child: newProvider.isLoading 
            ? CircularProgressIndicator()
            : Text('Call API'),
        );
      },
    );
  }
  
  Future<void> _callAPI(BuildContext context) async {
    final newProvider = Provider.of<NewProvider>(context, listen: false);
    final success = await newProvider.callNewAPI('value1', 123);
    
    if (success) {
      // Handle success
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(newProvider.errorMessage ?? 'Error')),
      );
    }
  }
}
```

## ⚠️ Lưu ý quan trọng

### 1. Data Type Mapping

**Backend expects specific types:**
```dart
// ❌ Wrong - Backend expects Integer
body: {
  'email': email,
  'code': code,  // String
}

// ✅ Correct - Backend expects Integer
body: {
  'email': email,
  'otp': intCode,  // Integer
}
```

### 2. Error Handling

**Comprehensive error handling:**
```dart
try {
  final response = await _httpClient.post(endpoint, body: data);
  
  if (response.statusCode == 200) {
    // Success
  } else {
    // Handle specific error codes
    if (response.statusCode == 400) {
      throw Exception('Bad Request: ${response.body}');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    }
  }
} catch (e) {
  // Log error for debugging
  print('API Error: $e');
  throw Exception('API call failed: $e');
}
```

### 3. Debug Logging

**Add debug logs for troubleshooting:**
```dart
Future<void> apiCall() async {
  print('=== DEBUG: API call started ===');
  print('Request data: $requestData');
  
  final response = await _httpClient.post(endpoint, body: requestData);
  
  print('=== DEBUG: Response status: ${response.statusCode} ===');
  print('=== DEBUG: Response body: ${response.body} ===');
}
```

### 4. Token Management

**Automatic token injection:**
```dart
// HttpClient automatically adds Bearer token
Map<String, String> _getHeaders() {
  final headers = Map<String, String>.from(ApiConstants.defaultHeaders);
  
  if (_accessToken != null) {
    headers['Authorization'] = 'Bearer $_accessToken';
  }
  
  return headers;
}
```

## 🎯 Best Practices

1. **Always use models** cho request/response
2. **Centralize API constants** trong một file
3. **Handle loading states** trong UI
4. **Show meaningful error messages** cho user
5. **Add debug logs** cho development
6. **Use Provider pattern** cho state management
7. **Validate data types** trước khi gửi API
8. **Handle network timeouts** appropriately

## 🔄 Testing Flow

1. **Registration** → User tạo account
2. **Email Verification** → User nhập OTP từ email
3. **Login** → User đăng nhập với credentials
4. **Token Management** → Auto-refresh và logout

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
