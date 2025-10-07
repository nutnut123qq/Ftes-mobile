/// Utility class để xử lý và parse error messages từ backend
class ErrorHandler {
  /// Parse error message từ exception
  static String parseError(dynamic error) {
    final errorString = error.toString();
    
    // Parse error từ backend API response
    if (errorString.contains('User with this email already exists')) {
      return 'Email này đã được sử dụng. Vui lòng sử dụng email khác.';
    }
    
    if (errorString.contains('Username already exists')) {
      return 'Tên người dùng này đã tồn tại. Vui lòng chọn tên khác.';
    }
    
    if (errorString.contains('Invalid email format')) {
      return 'Email không hợp lệ. Vui lòng kiểm tra lại.';
    }
    
    if (errorString.contains('Password is too short')) {
      return 'Mật khẩu quá ngắn. Vui lòng nhập ít nhất 8 ký tự.';
    }
    
    if (errorString.contains('Password is too weak')) {
      return 'Mật khẩu quá yếu. Vui lòng sử dụng mật khẩu mạnh hơn.';
    }
    
    if (errorString.contains('Invalid credentials') || 
        errorString.contains('Login failed: 401')) {
      return 'Email hoặc mật khẩu không đúng. Vui lòng thử lại.';
    }
    
    if (errorString.contains('User not found')) {
      return 'Không tìm thấy người dùng. Vui lòng kiểm tra lại thông tin.';
    }
    
    if (errorString.contains('Invalid OTP') || errorString.contains('OTP')) {
      return 'Mã OTP không chính xác. Vui lòng thử lại.';
    }
    
    if (errorString.contains('OTP expired')) {
      return 'Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới.';
    }
    
    if (errorString.contains('Account not activated')) {
      return 'Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email.';
    }
    
    if (errorString.contains('Account is locked') || 
        errorString.contains('Account disabled')) {
      return 'Tài khoản đã bị khóa. Vui lòng liên hệ quản trị viên.';
    }
    
    if (errorString.contains('Token expired') || 
        errorString.contains('Unauthorized')) {
      return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
    }
    
    if (errorString.contains('Network error') || 
        errorString.contains('SocketException') ||
        errorString.contains('Failed host lookup')) {
      return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet.';
    }
    
    if (errorString.contains('TimeoutException') || 
        errorString.contains('timed out')) {
      return 'Yêu cầu quá thời gian chờ. Vui lòng thử lại.';
    }
    
    if (errorString.contains('400')) {
      return 'Dữ liệu không hợp lệ. Vui lòng kiểm tra lại thông tin.';
    }
    
    if (errorString.contains('403')) {
      return 'Bạn không có quyền thực hiện thao tác này.';
    }
    
    if (errorString.contains('404')) {
      return 'Không tìm thấy dữ liệu yêu cầu.';
    }
    
    if (errorString.contains('500') || errorString.contains('Server error')) {
      return 'Lỗi máy chủ. Vui lòng thử lại sau.';
    }
    
    if (errorString.contains('M004_DUPLICATE')) {
      if (errorString.contains('email')) {
        return 'Email này đã được sử dụng. Vui lòng sử dụng email khác.';
      } else if (errorString.contains('username')) {
        return 'Tên người dùng này đã tồn tại. Vui lòng chọn tên khác.';
      }
      return 'Dữ liệu đã tồn tại trong hệ thống.';
    }
    
    if (errorString.contains('BACKEND_CONSTRAINT_VIOLATION')) {
      return 'Lỗi ràng buộc dữ liệu. Vui lòng kiểm tra lại thông tin.';
    }
    
    // Default error message
    return 'Đã xảy ra lỗi. Vui lòng thử lại sau.';
  }
  
  /// Parse register error messages
  static String parseRegisterError(dynamic error) {
    final errorString = error.toString();
    
    if (errorString.contains('already exists')) {
      if (errorString.contains('email')) {
        return 'Email này đã được đăng ký. Vui lòng sử dụng email khác hoặc đăng nhập.';
      } else if (errorString.contains('username')) {
        return 'Tên người dùng đã tồn tại. Vui lòng chọn tên khác.';
      }
      return 'Thông tin đã tồn tại trong hệ thống.';
    }
    
    return parseError(error);
  }
  
  /// Parse login error messages
  static String parseLoginError(dynamic error) {
    final errorString = error.toString();
    
    if (errorString.contains('401') || 
        errorString.contains('Invalid credentials')) {
      return 'Email hoặc mật khẩu không đúng.';
    }
    
    if (errorString.contains('not activated')) {
      return 'Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email để kích hoạt.';
    }
    
    return parseError(error);
  }
  
  /// Parse verification error messages
  static String parseVerificationError(dynamic error) {
    final errorString = error.toString();
    
    if (errorString.contains('Invalid') && errorString.contains('OTP')) {
      return 'Mã xác thực không đúng. Vui lòng kiểm tra lại.';
    }
    
    if (errorString.contains('expired')) {
      return 'Mã xác thực đã hết hạn. Vui lòng yêu cầu mã mới.';
    }
    
    return parseError(error);
  }
  
  /// Extract error message from HTTP response body
  static String extractErrorFromResponse(String responseBody) {
    try {
      // Thử parse JSON response
      final pattern = RegExp(r'"message"\s*:\s*"([^"]+)"');
      final match = pattern.firstMatch(responseBody);
      if (match != null && match.group(1) != null) {
        return parseError(match.group(1)!);
      }
    } catch (e) {
      // Ignore parse errors
    }
    
    return parseError(responseBody);
  }
}
