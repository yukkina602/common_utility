// ignore_for_file: depend_on_referenced_packages

import 'package:web/web.dart' as web;

/// Web page controller
/// 
/// #### Todo
/// This class is flutter_web only.
/// 
class WebpageController {
  /// Open new window to url link
  /// 
  /// ### Parameter
  /// ```dart
  /// String url
  /// int? windowWidth
  /// int? windowHeight
  /// ```
  /// 
  static openNewWindow({
    required String url,
    int? windowWidth,
    int? windowHeight,
  }) {
    // 「new window」と「width=xxx,height=xxx」を指定することで、新しいウィンドウで開ける
    web.window.open(
      url,
      "new window",
      "width=${windowWidth ?? 800},height=${windowHeight ?? 600}",
    );
  }
}