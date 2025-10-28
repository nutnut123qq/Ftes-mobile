/// Constants for Auth feature
class AuthConstants {
  // Error messages
  static const String errorNoInternet = 'Không có kết nối internet';
  static const String errorServer = 'Lỗi máy chủ, vui lòng thử lại sau';
  static const String errorCache = 'Lỗi bộ nhớ đệm';
  static const String errorAuth = 'Xác thực thất bại';
  static const String errorValidation = 'Dữ liệu không hợp lệ';
  static const String errorInvalidResponse = 'Định dạng phản hồi không hợp lệ';
  static const String errorLoginFailed = 'Đăng nhập thất bại';
  static const String errorGoogleCancelled = 'Đã hủy đăng nhập Google';
  static const String errorGetUserInfo = 'Không thể lấy thông tin người dùng';
  static const String errorRegisterFailed = 'Đăng ký thất bại';
  static const String errorVerifyOTPFailed = 'Xác thực OTP thất bại';
  static const String errorResendCodeFailed = 'Gửi lại mã xác thực thất bại';
  static const String errorSendForgotEmailFailed = 'Gửi email quên mật khẩu thất bại';
  static const String errorVerifyForgotOTPFailed = 'Xác thực OTP cho quên mật khẩu thất bại';
  static const String errorResetPasswordFailed = 'Đặt lại mật khẩu thất bại';
  static const String errorAccessTokenMissing = 'Không tìm thấy access token. Vui lòng thực hiện lại.';

  // Success messages
  static const String successLogin = 'Đăng nhập thành công';
  static const String successRegister = 'Đăng ký thành công';
  static const String successResendCode = 'Đã gửi lại mã xác thực';
  static const String successResetPassword = 'Đặt lại mật khẩu thành công';

  // Loading messages
  static const String loadingAuth = 'Đang xác thực...';
  static const String loadingRegister = 'Đang đăng ký...';
  static const String loadingVerifyOTP = 'Đang xác thực OTP...';

  // Default values
  static const int defaultMaxRetries = 3;
  static const Duration defaultTimeout = Duration(seconds: 20);
}


