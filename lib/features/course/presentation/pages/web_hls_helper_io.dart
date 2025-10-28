import 'web_hls_helper.dart';

class _WebHlsHelperIO implements WebHlsHelper {
  @override
  void cleanupWrapper() {}

  @override
  void initHlsPlayer(String hlsUrl) {}
}

WebHlsHelper createWebHlsHelper() => _WebHlsHelperIO();


