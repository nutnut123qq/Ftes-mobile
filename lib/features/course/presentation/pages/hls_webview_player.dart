import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HlsWebViewPlayer extends StatefulWidget {
  final String hlsUrl;

  const HlsWebViewPlayer({super.key, required this.hlsUrl});

  @override
  State<HlsWebViewPlayer> createState() => _HlsWebViewPlayerState();
}

class _HlsWebViewPlayerState extends State<HlsWebViewPlayer> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const SizedBox.shrink();
    }

    final html = _buildHtml(widget.hlsUrl);
    return InAppWebView(
      initialSettings: InAppWebViewSettings(
        mediaPlaybackRequiresUserGesture: false,
        javaScriptEnabled: true,
        allowsInlineMediaPlayback: true,
        transparentBackground: true,
      ),
      initialData: InAppWebViewInitialData(data: html),
    );
  }

  String _buildHtml(String url) {
    return '''
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
    <style>
      html, body { margin:0; padding:0; background:#000; height:100%; overflow:hidden; }
      #player { width:100vw; height:100vh; object-fit:contain; background:#000; }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
  </head>
  <body>
    <video id="player" controls autoplay playsinline muted></video>
    <script>
      (function(){
        var video = document.getElementById('player');
        var src = ${_jsString(url)};
        if (window.Hls && Hls.isSupported()) {
          var hls = new Hls({lowLatencyMode:false});
          hls.loadSource(src);
          hls.attachMedia(video);
          hls.on(Hls.Events.MANIFEST_PARSED, function(){
            var p = video.play();
            if (p && p.catch) { p.catch(function(e){ console.log('autoplay error', e); }); }
          });
        } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
          video.src = src;
          var p = video.play();
          if (p && p.catch) { p.catch(function(e){ console.log('autoplay error', e); }); }
        } else {
          video.innerHTML = 'HLS not supported';
        }
      })();
    </script>
  </body>
</html>
''';
  }

  String _jsString(String v) {
    return "'${v.replaceAll("'", "\\'")}'";
  }
}


