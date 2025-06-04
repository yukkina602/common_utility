/// スキャナ種別
/// 
enum ScannerType {
  /// 不明
  unknown,
  /// Blue bird
  bluebird,
  /// Camera
  camera,
  /// HoneyWell
  honeywell,
  /// UnItec
  unitech,
  /// USBKeyboard
  usbKeyboard,
  /// Zebra
  zebra,
}

/// ラベルからスキャナ種別の取得
/// 
extension ScannerTypeStringExtension on String {
  ScannerType get scannerType {
    switch (this) {
      case 'bluebird':
        return ScannerType.bluebird;
      case 'camera':
        return ScannerType.camera;
      case 'honeywell':
        return ScannerType.honeywell;
      case 'unitech':
        return ScannerType.unitech;
      case 'usbKeyboard':
        return ScannerType.usbKeyboard;
      case 'zebra':
        return ScannerType.zebra;
      case 'unknown':
      default:
        return ScannerType.unknown;
    }
  }
}

/// スキャナ種別のラベル取得
/// 
extension ScannerTypeExtension on ScannerType {
  String get string {
    switch (this) {
      case ScannerType.bluebird:
        return 'bluebird';
      case ScannerType.camera:
        return 'camera';
      case ScannerType.honeywell:
        return 'honeywell';
      case ScannerType.unitech:
        return 'unitech';
      case ScannerType.usbKeyboard:
        return 'usbKeyboard';
      case ScannerType.zebra:
        return 'zebra';
      case ScannerType.unknown:
        return 'unknown';
    }
  }
}
