// Provide a platform-agnostic interface and factory for web HLS operations
// Actual implementations live in platform-specific files via conditional imports

// Conditional import: IO (mobile/desktop) fallback vs Web impl
import 'web_hls_helper_io.dart'
    if (dart.library.html) 'web_hls_helper_web.dart';

/// Platform-agnostic interface
abstract class WebHlsHelper {
  void cleanupWrapper();
  void initHlsPlayer(String hlsUrl);
}

// Factory to get the platform implementation
WebHlsHelper getWebHlsHelper() => createWebHlsHelper();


