import 'dart:async';

import 'package:flutter/material.dart';

/// 画面操作
/// 
class Navigation {
  /// 画面遷移
  /// 
  /// ### Parameter
  /// ```dart
  /// BuildContext context "エレメント"
  /// Widget nextPage "遷移先のページ"
  /// FutureOr Function(dynamic)? afterProcess "戻った場合に行う処理"
  /// ```
  /// 
  /// ### Return
  /// Type: `dynamic`
  /// 
  static Future<dynamic> transition(BuildContext context, Widget nextPage, {FutureOr Function(dynamic)? afterProcess}) async {
    return await Navigator.push(context, MaterialPageRoute(
      builder: (_) => nextPage,
    )).then((value) {
      afterProcess != null ? afterProcess(value) : null;
    });
  }
}