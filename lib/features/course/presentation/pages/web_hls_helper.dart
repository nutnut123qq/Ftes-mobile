// Provide a platform-agnostic interface for web HLS operations
// Actual implementations live in platform-specific files via conditional imports

import 'web_hls_helper_base.dart';
import 'web_hls_helper_io.dart'
    if (dart.library.html) 'web_hls_helper_web.dart';

// Factory to get the platform implementation
WebHlsHelper getWebHlsHelper() => createWebHlsHelper();


