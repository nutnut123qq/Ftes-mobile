// Web implementation
// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: depend_on_referenced_packages
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

Widget buildWebYouTubePlayer(String videoId) {
  final viewType = 'youtube-player-$videoId-${DateTime.now().millisecondsSinceEpoch}';
  
  // Register the view factory
  ui_web.platformViewRegistry.registerViewFactory(
    viewType,
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

  return Container(
    color: Colors.black,
    child: HtmlElementView(viewType: viewType),
  );
}
