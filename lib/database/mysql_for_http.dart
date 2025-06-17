import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// HTTPアクセスでMySQLを操作するクラス 
/// (MySQL control for HTTP access.)
///
/// ### Todo 
/// This class is MySQL controller.
/// 
/// ### Use
/// Use in enviroment backend of `Laravel`. 
/// 
/// ---
/// このクラスを利用する場合は、バックエンドを`Laravel`で構築することを推奨します。
/// 
/// 
class MySQLForHTTP {
  /// POSTしてデータを取得 (URL Post)
  ///
  /// ### Parameter
  /// ```dart
  /// String url "リクエストURL" @required
  /// Object? value "条件"
  /// ```
  ///
  /// ### Return
  /// Type: `List<Map<String, dynamic>>` 
  /// 
  /// SELECTクエリの実行結果
  ///
  /// ### Reference
  /// `■ Single data`
  /// ```dart
  /// var result = await MySQLForHTTP.postSelect(
  ///   url: "https://www.example.com/get/data",
  ///   values: { "hoge": 1 },
  /// );
  ///
  /// if (result.isNotEmpty) {
  ///   var id = int.parse("${result.first["id"]}");
  ///   var name = "${result.first["name"]}";
  /// }
  /// ```
  ///
  /// `■ Multi row data`
  /// ```dart
  /// var result = await MySQLForHTTP.postSelect(
  ///   url: "https://www.example.com/get/data",
  ///   values: { "hoge": 1 },
  /// );
  ///
  /// for (var row in result) {
  ///   var id = int.parse("${row["id"]}");
  ///   var name = "${row["name"]}";
  /// }
  /// ```
  ///
  static Future<List<Map<String, dynamic>>> postSelect({required String url, Map<String, Object?>? values}) async {
    var resultMap = <Map<String, dynamic>>[];

    try {
      // アクセス先にPOSTしてデータを受け取る
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(values),
      );

      if (response.statusCode == 505) {
        throw Exception("Select query Error - ${response.body}");
      }

      var getData = jsonDecode(response.body) as List;

      // 取得したデータをアクセスしやすい形に変換
      for (var data in getData) {
        var dataMap = data as Map<dynamic, dynamic>;
        var addData = <String, dynamic>{};
        dataMap.forEach((key, value) {
          addData.addAll({
            "$key": value,
          });
        });

        resultMap.add(addData);
      }
    } catch (e) {
      throw Exception(e);
    }

    return resultMap;
  }

  /// URLとパラメータのみでクエリを実行
  /// 
  /// ### Parameter
  /// ```dart
  /// String url "リクエストURL" @required
  /// Map<String, Object?>? value "パラメータ"
  /// ```
  ///
  /// ### Return
  /// Type: `bool` 
  /// ```dart
  /// @true "正常終了"
  /// ```
  /// 
  /// ### Reference
  /// ```dart
  /// await MySQLForHTTP.postURL(
  ///   url: "https://hoge.com/query/test",
  ///   values: {
  ///     "name": "HOGE",
  ///     "name-2": "FUGA",
  ///   }
  /// );
  /// ```
  /// 
  /// ---
  /// Insertした後に別のテーブルにInsertや、
  /// 複数のテーブルをUpdateする際などに、
  /// こちらのメソッドを利用することで、
  /// 同一の`Transaction`内でクエリを実行できるように、
  /// バックエンドを構築する。
  /// 
  static Future<bool> postURL({required String url, Map<String, Object?>? values}) async {
    try {
      // アクセス先にPOSTしてデータを受け取る
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(values),
      );

      if (response.statusCode == 505) {
        debugPrint("Error on execute query in only url access. => ${response.body}");
        return false; // 異常
      } else {
        return true; // 正常
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// データベースからデータを取得 (URL Post)
  ///
  /// ### Parameter
  /// ```dart
  /// String url "リクエストURL" @required
  /// String query "SQL文" @required
  /// Object? value "検索条件"
  /// ```
  ///
  /// ### Return
  /// Type: `List<Map<String, dynamic>>` 
  /// 
  /// SELECTクエリの実行結果
  ///
  /// ### Reference
  /// `■ Single data`
  /// ```dart
  /// var result = await MySQLForHTTP.select(
  ///   url: "https://www.example.com/get/data",
  ///   query: "select * from users where id = ?",
  ///   values: [ 1 ],
  /// );
  ///
  /// if (result.isNotEmpty) {
  ///   var id = int.parse("${result.first["id"]}");
  ///   var name = "${result.first["name"]}";
  /// }
  /// ```
  ///
  /// `■ Multi row data`
  /// ```dart
  /// var result = await MySQLForHTTP.select(
  ///   url: "https://www.example.com/get/data",
  ///   query: "select * from users where id <> ?",
  ///   values: [ 1 ],
  /// );
  ///
  /// for (var row in result) {
  ///   var id = int.parse("${row["id"]}");
  ///   var name = "${row["name"]}";
  /// }
  /// ```
  ///
  static Future<List<Map<String, dynamic>>> select({required String url, required String query, List<Object?>? values}) async {
    var resultMap = <Map<String, dynamic>>[];
    var parameter = "";

    if (values != null) {
      for (var param in values) {
        parameter += parameter == "" ? "$param" : ",$param";
      }
    }

    try {
      // アクセス先にPOSTしてデータを受け取る
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "query": query,
          "parameter": parameter,
        }),
      );

      if (response.statusCode == 505) {
        throw Exception("Select query Error - ${response.body}");
      }

      var getData = jsonDecode(response.body) as List;

      // 取得したデータをアクセスしやすい形に変換
      for (var data in getData) {
        var dataMap = data as Map<dynamic, dynamic>;
        var addData = <String, dynamic>{};
        dataMap.forEach((key, value) {
          addData.addAll({
            "$key": value,
          });
        });

        resultMap.add(addData);
      }
    } catch (e) {
      throw Exception(e);
    }

    return resultMap;
  }

  /// Updateの実行
  ///
  /// ### Parameter
  /// ```dart
  /// String url "リクエストURL" @required
  /// String query "SQL文" @required
  /// Object? value "条件"
  /// ```
  ///
  /// ### Return
  /// Type: `bool` 
  /// ```dart
  /// @true "正常終了"
  /// ```
  ///
  static Future<bool> update({required String url, required String query, List<Object?>? values}) async {
    var parameter = "";

    if (values != null) {
      for (var param in values) {
        parameter += parameter == "" ? "$param" : ",$param";
      }
    }

    try {
      // アクセス先にPOSTしてデータを受け取る
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "query": query,
          "parameter": parameter,
        }),
      );

      if (response.statusCode == 505) {
        debugPrint("Update query Error - ${response.body}");
        return false; // 異常
      } else {
        return true; // 正常
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Insertの実行
  ///
  /// ### Parameter
  /// ```dart
  /// String url "リクエストURL" @required
  /// String query "SQL文" @required
  /// Object? value "条件"
  /// ```
  ///
  /// ### Return
  /// Type: `bool` 
  /// ```dart
  /// @true "正常終了"
  /// ```
  ///
  static Future<bool> insert({required String url, required String query, List<Object?>? values}) async {
    var parameter = "";

    if (values != null) {
      for (var param in values) {
        parameter += parameter == "" ? "$param" : ",$param";
      }
    }

    try {
      // アクセス先にPOSTしてデータを受け取る
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "query": query,
          "parameter": parameter,
        }),
      );

      if (response.statusCode == 505) {
        debugPrint("Insert query Error - ${response.body}");
        return false; // 異常
      } else {
        return true; // 正常
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Insertの実行し、IDを取得
  ///
  /// ### Parameter
  /// ```dart
  /// String url "リクエストURL" @required
  /// String query "SQL文" @required
  /// Object? value "条件"
  /// ```
  ///
  /// ### Return
  /// Type: `int?` 
  /// 
  /// エラーの場合は`null`で返します
  ///
  static Future<int?> insertForGetID({required String url, required String query, List<Object?>? values}) async {
    var parameter = "";

    if (values != null) {
      for (var param in values) {
        parameter += parameter == "" ? "$param" : ",$param";
      }
    }

    try {
      // アクセス先にPOSTしてデータを受け取る
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "query": query,
          "parameter": parameter,
        }),
      );

      if (response.statusCode == 505) {
        debugPrint("Insert for get ID query Error - ${response.body}");
        return null; // 異常
      } else {
        return int.parse(response.body); // 正常
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Deleteの実行
  ///
  /// ### Parameter
  /// ```dart
  /// String url "リクエストURL" @required
  /// String query "SQL文" @required
  /// Object? value "条件"
  /// ```
  ///
  /// ### Return
  /// Type: `bool` 
  /// ```dart
  /// @true "正常終了"
  /// ```
  ///
  static Future<bool> delete({required String url, required String query, List<Object?>? values}) async {
    var parameter = "";

    if (values != null) {
      for (var param in values) {
        parameter += parameter == "" ? "$param" : ",$param";
      }
    }

    try {
      // アクセス先にPOSTしてデータを受け取る
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "query": query,
          "parameter": parameter,
        }),
      );

      if (response.statusCode == 505) {
        debugPrint("Delete query Error - ${response.body}");
        return false; // 異常
      } else {
        return true; // 正常
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}