import '../qr_barcode_scanner.dart';

import 'dart:async';

import 'package:flutter/material.dart';

/// USBキーボード入力によるスキャン
/// 
class UsbKeyboardScanner implements BarcodeScanner {
  int maxCharacterInputIntervalMs;
  Timer? _debounceTimer;

  late ValueChanged<BarcodeScanResult> _onScan;
  late FocusNode _focusNode;
  late var _externalScanString = '';
  late var isRunning = true;

  UsbKeyboardScanner({
    this.maxCharacterInputIntervalMs = 50,
  });

  @override
  Widget? buildUI(ScannerConfiguration configuration, BuildContext context) =>
    KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: const SizedBox(),
    );

  @override
  Future<void> configure({
    required ScannerConfiguration configuration,
    required ValueChanged<BarcodeScanResult> onScan,
  }) async {
    controller = UsbKeyboardScannerController(this);
    _onScan = onScan;
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
  }

  @override
  ScannerProperties get properties => const ScannerProperties(
    supportedFormats: {
      BarcodeFormat.aztec,
      BarcodeFormat.code128,
      BarcodeFormat.code39,
      BarcodeFormat.code93,
      BarcodeFormat.dataMatrix,
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.itf,
      BarcodeFormat.pdf417,
      BarcodeFormat.qr,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
    },
    hasUI: true,
  );

  @override
  late BarcodeScannerController controller;

  void _onKeyEvent(KeyEvent event) {
    if (!isRunning) return;

    if (event.character != null && event.character!.isNotEmpty) {
      _externalScanString += event.character!;
    }

    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(
      Duration(milliseconds: maxCharacterInputIntervalMs),
      () async {
        //trim spaces, tabs and `null` characters (\u0000)
        final finalScanString = _externalScanString.trim().replaceAll('\u0000', '');
        _externalScanString = '';
        _onScan(
          BarcodeScanResult(
            code: finalScanString,
            format: null,
            source: ScannerType.usbKeyboard,
          ),
        );
      },
    );
  }

  void pause() {
    isRunning = false;
  }

  void start() {
    isRunning = true;
  }
}

/// コントローラ
/// 
class UsbKeyboardScannerController extends BarcodeScannerController {
  final UsbKeyboardScanner _scanner;

  UsbKeyboardScannerController(this._scanner);

  @override
  void pause() {
    _scanner.pause();
  }

  @override
  void start() {
    _scanner.start();
  }

  @override
  bool get isControllerSupported => true;
}