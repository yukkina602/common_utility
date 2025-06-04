import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferencesの操作
/// 
class SharedDatas {
  /// SharedPreferencesのインスタンスを取得
  /// 
  /// ### Return
  /// Type: `SharedPreferences`
  /// 
  static Future<SharedPreferences> _getPref() async {
    return await SharedPreferences.getInstance();
  }

  /// データの存在チェック
  /// 
  /// ### Parameter
  /// ```dart
  /// String key "キーワード"
  /// ```
  /// 
  /// ### Return
  /// Type: `bool`
  /// 
  /// 存在する場合は`true`
  /// 
  static Future<bool> exists(String key) async => 
    await _getPref().then((pref) => pref.containsKey(key));

  /// 型別のデータ保存
  /// 
  /// ### Parameter
  /// ```dart
  /// String key "キーワード"
  /// String value "格納データ"
  /// ```
  /// 
  /// ### Return
  /// Type: `bool`
  /// 
  static Future<bool> setString(String key, String value) async => 
    await _getPref().then((pref) => pref.setString(key, value));

  static Future<bool> setInt(String key, int value) async => 
    await _getPref().then((pref) => pref.setInt(key, value));

  static Future<bool> setBool(String key, bool value) async => 
    await _getPref().then((pref) => pref.setBool(key, value));

  static Future<bool> setDouble(String key, double value) async => 
    await _getPref().then((pref) => pref.setDouble(key, value));

  /// 型別のデータ取得
  /// 
  /// ### Parameter
  /// ```dart
  /// String key "キーワード"
  /// ```
  /// 
  /// ### Return
  /// Type: `String`
  /// 
  /// nullや空は「""」で返す
  /// 
  static Future<String> getString(String key) async => 
    await _getPref().then((pref) => pref.getString(key) ?? "");

  /// ### Return
  /// Type: `int?`
  /// 
  /// Null Safety
  /// 
  static Future<int?> getInt(String key) async => 
    await _getPref().then((pref) => pref.getInt(key));  

  /// ### Return
  /// Type: `bool?`
  /// 
  /// Null Safety
  /// 
  static Future<bool?> getBool(String key) async => 
    await _getPref().then((pref) => pref.getBool(key));

  /// ### Return
  /// Type: `double?`
  /// 
  /// Null Safety
  /// 
  static Future<double?> getDouble(String key) async => 
    await _getPref().then((pref) => pref.getDouble(key));

  /// データの削除
  /// 
  /// ### Parameter
  /// ```dart
  /// String key "キーワード"
  /// ```
  /// 
  /// ### Return
  /// Type: `bool`
  /// 
  static Future<bool> remove(String key) async => 
    await _getPref().then((pref) => pref.remove(key));
}