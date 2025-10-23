// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:ui' as ui;
import 'dart:html' as html;

void registerYouTubeViewFactory(String videoId) {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
    'youtube-$videoId',
    (int viewId) {
      final iframe = html.IFrameElement()
        ..src = 'https://www.youtube.com/embed/$videoId?autoplay=1&controls=1&rel=0'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture'
        ..allowFullscreen = true;
      return iframe;
    },
  );
}
