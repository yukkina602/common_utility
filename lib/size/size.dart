import 'package:flutter/widgets.dart';

/// 画面サイズ
/// 
extension ScreenSize on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
}
