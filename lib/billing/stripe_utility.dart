import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:http/http.dart' as http;

/// `Stripe`サービスのユーティリティ
/// 
class StripeUtility {
  /// 決済のエンドポイント
  static final _endPoint = Uri.https('api.stripe.com', 'v1/payment_intents');

  /// 初期化
  /// 
  /// ### Parameter
  /// ```dart
  /// String publicKey "パブリックキー" @required
  /// String? merchantId "マーチャントID"
  /// ```
  /// 
  Future<void> initialize({
    required String publicKey,
    String? merchantId,
  }) async {
    Stripe.publishableKey = publicKey;
    Stripe.merchantIdentifier = merchantId;

    await Stripe.instance.applySettings();
  }

  /// 決算処理情報を準備
  /// 
  /// ### Parameter
  /// ```dart
  /// int price "金額"
  /// String secretKey "シークレットキー" @required
  /// ```
  /// 
  /// ### Todo
  /// 決算情報を作成するにあたり、
  /// 決算金額が`50円未満`になっている場合に、
  /// `手数料等の関係でエラー`が帰ってきてしまうので注意。
  /// Stripeでカード決算を行う場合は、
  /// 必ず`50円以上`の取引になるようにシステムで調整を行うこと。
  /// 
  Future<dynamic> getPaymentIntent(
    int price, {
    required String secretKey,
  }) async {
    // POSTするリクエストのヘッダ
    final requestHeader = {
      'Authorization': "Bearer $secretKey",
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    // POSTするリクエストの中身
    final requestBody = {
      'amount': '$price',
      'currency': 'jpy',
      'payment_method_types[]': 'card',
    };

    // 決算処理を行う先にリクエストをPOST
    var response = await http.post(
      _endPoint,
      headers: requestHeader,
      body: requestBody,
    );

    return jsonDecode(response.body);
  }
}