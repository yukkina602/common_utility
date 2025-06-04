import 'package:flutter/material.dart';

/// メッセージダイアログの表示
/// 
/// ### Paremeter
/// ```dart
/// BuildContext context
/// DialogTypes type
/// Widget? icon
/// Widget? title
/// String? titleText
/// TextStyle? titleTextStyle
/// Widget? message
/// String? messageText
/// TextStyle? messageTextStyle
/// List<Widget>? actions
/// bool barrierDismissible = true
/// Color? barrierColor
/// EdgeInsetsGeometry? iconPagging
/// EdgeInsetsGeometry? titlePagging
/// EdgeInsetsGeometry? contentPadding
/// EdgeInsetsGeometry? buttonPadding
/// EdgeInsets? insetPadding
/// ShapeBorder? shape
/// String? okText
/// String? cancelText
/// String? closeText
/// TextStyle? okTextStyle
/// TextStyle? cancelTextStyle
/// TextStyle? closeTextStyle
/// double? okTextScale
/// double? cancelTextScale
/// double? closeTextScale
/// ButtonStyle? okButtonStyle
/// ButtonStyle? cancelButtonStyle
/// ButtonStyle? closeButtonStyle
/// Function()? onConfirm
/// Function()? onCancel
/// Function()? onClosing
/// ```
/// 
Future<void> showCustomDialog(
  BuildContext context, {
  required DialogTypes type,
  Widget? icon,
  Widget? title,
  String? titleText,
  TextStyle? titleTextStyle,
  Widget? message,
  String? messageText,
  TextStyle? messageTextStyle,
  List<Widget>? actions,
  bool barrierDismissible = true,
  Color? barrierColor,
  EdgeInsetsGeometry? iconPagging,
  EdgeInsetsGeometry? titlePagging,
  EdgeInsetsGeometry? contentPadding,
  EdgeInsetsGeometry? buttonPadding,
  EdgeInsets? insetPadding,
  ShapeBorder? shape,
  String? okText,
  String? cancelText,
  String? closeText,
  TextStyle? okTextStyle,
  TextStyle? cancelTextStyle,
  TextStyle? closeTextStyle,
  double? okTextScale,
  double? cancelTextScale,
  double? closeTextScale,
  ButtonStyle? okButtonStyle,
  ButtonStyle? cancelButtonStyle,
  ButtonStyle? closeButtonStyle,
  Function()? onConfirm,
  Function()? onCancel,
  Function()? onClosing,
}) async => await showDialog<AlertDialog>(
  context: context, 
  barrierColor: barrierColor,
  barrierDismissible: barrierDismissible,
  builder: (_) => AlertDialog(
    shape: shape,
    iconPadding: iconPagging,
    titlePadding: titlePagging,
    contentPadding: contentPadding,
    buttonPadding: buttonPadding,
    insetPadding: insetPadding,
    icon: icon,
    // テキストの指定がある場合は、Widgetの設定を無視してテキスト表示を優先
    title: titleText != null ? Text(
      titleText,
      textScaler: TextScaler.linear(1.0),
      style: titleTextStyle ?? TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ) : title,
    content: message ?? (messageText != null ? Text(
      messageText,
      textScaler: TextScaler.linear(1.0),
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
    ) : null),
    actions: type == DialogTypes.custom 
      ? actions : [_getButtons(
        context, 
        type,
        okText: okText,
        cancelText: cancelText,
        closeText: closeText,
        okTextStyle: okTextStyle,
        cancelTextStyle: cancelTextStyle,
        closeTextStyle: closeTextStyle,
        okTextScale: okTextScale,
        cancelTextScale: cancelTextScale,
        closeTextScale: closeTextScale,
        okButtonStyle: okButtonStyle,
        cancelButtonStyle: cancelButtonStyle,
        closeButtonStyle: closeButtonStyle,
        onConfirm: onConfirm,
        onCancel: onCancel,
        onClosing: onClosing,
      )],
  ),
);

/// ダイアログ種別
/// 
enum DialogTypes {
  info,
  error,
  confirm,
  custom,
}

/// ダイアログのボタンの取得
/// 
/// ### Parameter
/// ```dart
/// BuildContext context
/// DialogTypes type
/// String? okText
/// String? cancelText
/// String? closeText
/// TextStyle? okTextStyle
/// TextStyle? cancelTextStyle
/// TextStyle? closeTextStyle
/// double? okTextScale
/// double? cancelTextScale
/// double? closeTextScale
/// ButtonStyle? okButtonStyle
/// ButtonStyle? cancelButtonStyle
/// ButtonStyle? closeButtonStyle
/// Function()? onConfirm
/// Function()? onCancel
/// Function()? onClosing
/// ```
/// 
/// ### Return
/// Type: `Widget`
/// 
Widget _getButtons(
  BuildContext context, 
  DialogTypes type, {
  String? okText,
  String? cancelText,
  String? closeText,
  TextStyle? okTextStyle,
  TextStyle? cancelTextStyle,
  TextStyle? closeTextStyle,
  double? okTextScale,
  double? cancelTextScale,
  double? closeTextScale,
  ButtonStyle? okButtonStyle,
  ButtonStyle? cancelButtonStyle,
  ButtonStyle? closeButtonStyle,
  Function()? onConfirm,
  Function()? onCancel,
  Function()? onClosing,
}) {
  switch (type) {
    case DialogTypes.info:
    case DialogTypes.error:
      return Container(
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: onClosing ?? () => Navigator.pop(context), 
          style: closeButtonStyle ?? ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
          ),
          child: Text(
            closeText ?? "閉じる",
            textScaler: TextScaler.linear(closeTextScale ?? 1.2),
            style: closeTextStyle ?? TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )
        ),
      );
    case DialogTypes.confirm:
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: onCancel ?? () => Navigator.pop(context), 
            style: cancelButtonStyle ?? ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey,
            ),
            child: Text(
              cancelText ?? "キャンセル",
              textScaler: TextScaler.linear(cancelTextScale ?? 1.2),
              style: cancelTextStyle ?? TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 10.0),
          ElevatedButton(
            onPressed: onConfirm ?? () {}, 
            style: okButtonStyle ?? ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
            ),
            child: Text(
              okText ?? "OK",
              textScaler: TextScaler.linear(okTextScale ?? 1.2),
              style: okTextStyle ?? TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          ),
        ],
      );
    case DialogTypes.custom:
      return SizedBox(width: 0.0, height: 0.0);
  }
}