// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:js' as js;
import 'web_hls_helper_base.dart';

class _WebHlsHelperWeb implements WebHlsHelper {
  @override
  void cleanupWrapper() {
    try {
      final wrapper = html.document.getElementById('hls-video-wrapper');
      wrapper?.remove();
    } catch (_) {}
  }

  @override
  void initHlsPlayer(String hlsUrl) {
    try {
      final old = html.document.getElementById('hls-video-wrapper');
      old?.remove();

      final wrapper = html.DivElement()
        ..id = 'hls-video-wrapper'
        ..style.position = 'fixed'
        ..style.top = '0'
        ..style.left = '0'
        ..style.width = '100vw'
        ..style.height = '100vh'
        ..style.zIndex = '0'
        ..style.backgroundColor = 'black';

      final video = html.VideoElement()
        ..id = 'hls-video-player'
        ..controls = true
        ..autoplay = true
        ..muted = false
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'contain';

      wrapper.append(video);

      final appContainer = html.document.querySelector('flt-scene-host') ?? html.document.body;
      appContainer?.append(wrapper);

      js.context.callMethod('eval', ['''
        var v = document.getElementById('hls-video-player');
        var src = "$hlsUrl";
        if (typeof Hls !== 'undefined' && Hls.isSupported()) {
          var hls = new Hls({debug: true});
          hls.loadSource(src);
          hls.attachMedia(v);
          hls.on(Hls.Events.MANIFEST_PARSED, () => v.play());
        } else if (v.canPlayType('application/vnd.apple.mpegurl')) {
          v.src = src;
          v.play();
        }
      ''']);
    } catch (_) {}
  }
}

WebHlsHelper createWebHlsHelper() => _WebHlsHelperWeb();


