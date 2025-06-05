import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Localizations
/// 
extension GlobalLocalizations on BuildContext {
  Iterable<LocalizationsDelegate<dynamic>> get defaultLocalizations => [
    GlobalWidgetsLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  Iterable<Locale> get defaultLocale => [
    Locale('ja', ''),
    Locale('en', ''),
  ];
}