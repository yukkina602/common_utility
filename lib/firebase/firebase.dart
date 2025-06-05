import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/fcm/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:http/http.dart' as http;

/// Firebase opration class.
/// 
class Firebase {
  /// Push Notification at HTTP v1
  /// 
  /// ### Parameter
  /// ```dart
  /// String projectId
  /// String serviceKey
  /// List<String> tokens
  /// String? title
  /// String? message
  /// String? option
  /// ```
  /// 
  static Future<void> fcmAtHTTPv1({
    required String projectId,
    required String serviceKey,
    required List<String> tokens,
    String? title,
    String? message,
    String? option,
  }) async {
    // Getting on Google Cloud access token
    final accessToken = await _getAccessToken(serviceKey);
    int counter = 0;

    for (var token in tokens) {
      // increment count
      counter++;

      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "message": {
            "token": token,
            "notification": {
              "title": title ?? "",
              "body": message ?? "",
            },
            "data": {
              "title": title ?? "",
              "body": message ?? "",
              "options": option ?? "",
            },
            "android": {
              "priority": "normal",
              "notification": {
                "title": title ?? "",
                "body": message ?? "",
              },
            },
            "apns": { // APNS (Apple Push Notification Service) setting (iOS only)
              "payload": {
                "aps": {
                  "alert": {
                    "title": title ?? "",
                    "body": message ?? "",
                  },
                  "sound": "true", // false = silent notification
                },
              },
            }
          },
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("----- Error sending push notification: ${response.body}");
      }

      // Waiting to not get caught in the restrictions
      if (counter == 100) {
        // Wait on 1 second
        await Future.delayed(const Duration(seconds: 1));

        // Reset count
        counter = 0;
      }
    }
  }

  /// Get on Google Cloud access token
  /// 
  /// ### Paremeter
  /// ```dart
  /// String serviceKey
  /// ```
  /// 
  /// ### Return
  /// Type: `String`
  /// 
  static Future<String> _getAccessToken(String serviceKey) async {
    // Getting on Service account
    final serviceAccountKey = json.decode(await rootBundle.loadString(serviceKey));
    
    // Getting on credential information
    final credential = serviceAccountKey.fromJson(serviceAccountKey);

    // Making to OAuth2 client
    final authClient = await clientViaServiceAccount(
      credential, 
      [ FirebaseCloudMessagingApi.firebaseMessagingScope ],
    );

    return authClient.credentials.accessToken.data;
  }

  /// Authenticate on SMS
  /// 
  /// ### Parameter
  /// ```dart
  /// String phoneNumber,
  ///  String cantoryCode = "+81",
  ///  Function(String, int?)? onAuth,
  ///  Function(FirebaseAuthException)? onFailed,
  ///  Function(PhoneAuthCredential)? onComplate,
  ///  Function(String)? onTimeout,
  ///  Duration? timeout
  /// ```
  /// 
  static Future<void> authPhoneNumber({
    required String phoneNumber,
    String cantoryCode = "+81",
    Function(String verificationId, int? token)? onAuth,
    Function(FirebaseAuthException exception)? onFailed,
    Function(PhoneAuthCredential credential)? onComplate,
    Function(String verificationId)? onTimeout,
    Duration? timeout,
  }) async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
    }
    
    // Verify on phone number
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "$cantoryCode${phoneNumber.substring(1)}",
      verificationCompleted: onComplate ?? (authCredential) {} , 
      verificationFailed: onFailed ?? (authException) {}, 
      codeSent: onAuth ?? (verificationId, forceResendingToken) {},
      codeAutoRetrievalTimeout: onTimeout ?? (verificationId) {},
      timeout: timeout ?? Duration(seconds: 30),
    );
  }

  /// Check on SMS code
  /// 
  /// ### Parameter
  /// ```dart
  /// String verificationId
  /// String code
  /// Function(UserCredential)? onSuccess
  /// Function(Object)? onError
  /// ```
  /// 
  static Future checkSMS({
    required String verificationId,
    required String code,
    Function(UserCredential credential)? onSuccess,
    Function(Object error)? onError,
  }) async {
    // Create a credential
    final credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);

    // Sign in
    await FirebaseAuth.instance.signInWithCredential(credential)
      .then(onSuccess ?? (_) {}, onError: onError ?? (_) {});
  }

  /// Get on Firebase Remote Config value
  /// 
  /// ### Parameter
  /// ```dart
  /// ```
  /// 
  /// ### Return
  /// Type: `dynamic`
  /// 
  /// ### Usage
  /// ```dart
  /// var name = Firebase.getRemoteConfig(key: "test", type: RemoteConfigType.string) as String;
  /// ```
  /// 
  static dynamic getRemoteConfig({required String key, required RemoteConfigType type}) {
    final instance = FirebaseRemoteConfig.instance;

    switch (type) {
      case RemoteConfigType.string:
        return instance.getString(key);
      case RemoteConfigType.int:
        return instance.getInt(key);
      case RemoteConfigType.double:
        return instance.getDouble(key);
      case RemoteConfigType.bool:
        return instance.getBool(key);
      case RemoteConfigType.value:
        return instance.getValue(key);
    }
  }
}

/// Remote config type
enum RemoteConfigType {
  string,
  int,
  double,
  bool,
  value,
}