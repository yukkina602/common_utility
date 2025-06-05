import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

/// 画面遷移のアニメーション
/// 
class AnimateNavigator {
  /// ブラックアウト
  /// 
  /// ### Parameter
  /// ```dart
  /// Widget nextPage
  /// RouteSettings? routeSetting
  /// int? animDuration "アニメーションの再生時間 (MilliSeconds)"
  /// ```
  /// 
  /// ### Return
  /// Type: `PageRouteBuilder`
  /// 
  static PageRouteBuilder blackOut(
    Widget nextPage, {
    RouteSettings? routeSetting,
    int? animDuration,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextPage,
      settings: routeSetting,
      transitionDuration: Duration(milliseconds: animDuration ?? 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final color = ColorTween(
          begin: Colors.transparent,
          end: Colors.black, // ブラックアウト
        ).animate(CurvedAnimation(
          parent: animation,
          // 前半
          curve: const Interval(
            0.0,
            0.5,
            curve: Curves.easeInOut,
          ),
        ));

        final opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          // 後半
          curve: const Interval(
            0.5,
            1.0,
            curve: Curves.easeInOut,
          ),
        ));

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Container(
              color: color.value,
              child: Opacity(
                opacity: opacity.value,
                child: child,
              ),
            );
          },
          child: child,
        );
      },
    );
  }

  /// ホワイトアウト
  /// 
  /// ### Parameter
  /// ```dart
  /// Widget nextPage
  /// RouteSettings? routeSetting
  /// int? animDuration "アニメーションの再生時間 (MilliSeconds)"
  /// ```
  /// 
  /// ### Return
  /// Type: `PageRouteBuilder`
  /// 
  static PageRouteBuilder whiteOut(
    Widget nextPage, {
    RouteSettings? routeSetting,
    int? animDuration,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextPage,
      settings: routeSetting,
      transitionDuration: Duration(milliseconds: animDuration ?? 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final color = ColorTween(
          begin: Colors.transparent,
          end: Colors.white, // ホワイトアウト
        ).animate(CurvedAnimation(
          parent: animation,
          // 前半
          curve: const Interval(
            0.0,
            0.5,
            curve: Curves.easeInOut,
          ),
        ));

        final opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          // 後半
          curve: const Interval(
            0.5,
            1.0,
            curve: Curves.easeInOut,
          ),
        ));

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Container(
              color: color.value,
              child: Opacity(
                opacity: opacity.value,
                child: child,
              ),
            );
          },
          child: child,
        );
      },
    );
  }

  /// フェードイン
  /// 
  /// ### Parameter
  /// ```dart
  /// Widget nextPage
  /// RouteSettings? routeSetting
  /// int? animDuration "アニメーションの再生時間 (MilliSeconds)"
  /// ```
  /// 
  /// ### Return
  /// Type: `PageRouteBuilder`
  /// 
  static PageRouteBuilder fadeIn(
    Widget nextPage, {
    RouteSettings? routeSetting,
    int? animDuration,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextPage,
      settings: routeSetting,
      transitionDuration: Duration(milliseconds: animDuration ?? 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const double begin = 0.0;
        const double end = 1.0;

        final Animatable<double> tween = Tween(
          begin: begin,
          end: end
        ).chain(
          CurveTween(curve: Curves.easeInOut),
        );
        final Animation<double> doubleAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: doubleAnimation,
          child: child,
        );
      },
    );
  }

  /// フリップを回転させるようなアニメーション
  /// 
  /// ### Parameter
  /// ```dart
  /// Widget nextPage
  /// RouteSettings? routeSetting
  /// int? animDuration "アニメーションの再生時間 (MilliSeconds)"
  /// ```
  /// 
  /// ### Return
  /// Type: `PageRouteBuilder`
  /// 
  static PageRouteBuilder flipRotation(
    Widget nextPage, {
    RouteSettings? routeSetting,
    int? animDuration,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextPage,
      settings: routeSetting,
      transitionDuration: Duration(milliseconds: animDuration ?? 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.linear),
            );
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(2 * 3.14 * flipAnimation.value),
              alignment: Alignment.center,
              child: child,
            );
          },
          child: child,
        );
      },
    );
  }

  /// 中央から拡大するようなアニメーション
  /// 
  /// ### Parameter
  /// ```dart
  /// Widget nextPage
  /// RouteSettings? routeSetting
  /// ```
  /// 
  /// ### Return
  /// Type: `PageRouteBuilder`
  /// 
  static PageRouteBuilder scaleUp(
    Widget nextPage, {
    RouteSettings? routeSetting,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextPage,
      settings: routeSetting,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  /// 下から上にスライドするアニメーションで画面遷移
  /// 
  /// ### Parameter
  /// ```dart
  /// Widget nextPage
  /// RouteSettings? routeSetting
  /// ```
  /// 
  /// ### Return
  /// Type: `PageRouteBuilder`
  /// 
  static PageRouteBuilder slideUp(
    Widget nextPage, {
    RouteSettings? routeSetting,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextPage,
      settings: routeSetting,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const Offset begin = Offset(0.0, 1.0); // 下から上
        const Offset end = Offset.zero;
        
        final Animatable<Offset> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
        final Animation<Offset> offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  /// 上から下にスライドするアニメーションで画面遷移
  /// 
  /// ### Parameter
  /// ```dart
  /// Widget nextPage
  /// RouteSettings? routeSetting
  /// ```
  /// 
  /// ### Return
  /// Type: `PageRouteBuilder`
  /// 
  static PageRouteBuilder slideDown(
    Widget nextPage, {
    RouteSettings? routeSetting,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextPage,
      settings: routeSetting,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const Offset begin = Offset(0.0, -1.0); // 上から下
        const Offset end = Offset.zero;
        
        final Animatable<Offset> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
        final Animation<Offset> offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  /// スプラッシュスクリーン表示での遷移
  /// 
  /// ### Parameter
  /// ```dart
  /// String imgFile
  /// Widget page
  /// double? imgSize
  /// BoxFit? imgFit
  /// Color? backgroundColor
  /// SplashTransition? transition
  /// PageTransitionType? transType
  /// int? animateDuration
  /// ```
  /// 
  /// ### Return
  /// Type: `AnimatedSplashScreen`
  /// 
  static AnimatedSplashScreen splash({
    required String imgFile,
    required Widget page,
    double? imgSize,
    BoxFit? imgFit,
    Color? backgroundColor,
    SplashTransition? transition,
    PageTransitionType? transType,
    int? animateDuration,
  }) {
    return AnimatedSplashScreen(
      splash: Image.asset(
        imgFile, 
        fit: imgFit ?? BoxFit.fill,
      ),
      splashIconSize: imgSize ?? 200,
      nextScreen: page,
      backgroundColor: backgroundColor ?? Colors.white,
      splashTransition: transition ?? SplashTransition.slideTransition,
      pageTransitionType: transType ?? PageTransitionType.fade,
      animationDuration: Duration(milliseconds: animateDuration ?? 1000),
    );
  }
}