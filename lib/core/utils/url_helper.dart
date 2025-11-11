import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';
import 'message_helper.dart';

/// Helper mở URL theo chuẩn toàn app
class UrlHelper {
  /// Mở đường dẫn ngoài trình duyệt/system application.
  /// Hiển thị thông báo lỗi qua MessageHelper nếu không mở được.
  static Future<void> openExternalUrl(
    BuildContext context, {
    required String url,
  }) async {
    if (url.isEmpty) {
      MessageHelper.showError(context, AppConstants.errorCannotOpenUrl);
      return;
    }

    final Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      MessageHelper.showError(context, AppConstants.errorCannotOpenUrl);
      return;
    }

    try {
      final Future<bool> launchFuture = launchUrl(
        uri,
        mode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
      );
      unawaited(
        launchFuture.then((launched) {
          if (!context.mounted) return;
          if (!launched) {
            MessageHelper.showError(context, AppConstants.errorCannotOpenUrl);
          }
        }).catchError((_) {
          if (!context.mounted) return;
          MessageHelper.showError(context, AppConstants.errorCannotOpenUrl);
        }),
      );
    } catch (_) {
      MessageHelper.showError(context, AppConstants.errorCannotOpenUrl);
    }
  }
}


