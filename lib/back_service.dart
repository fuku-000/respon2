import 'dart:async';
import 'dart:io';
import 'main.dart';
import 'notification_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
import 'package:flutter_background_service/flutter_background_service.dart';

Future initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future onStart(ServiceInstance service) async {
  print("onStart called.");
  try {
    await Firebase.initializeApp();
    tz.initializeTimeZones(); // タイムゾーンの初期化
    tz.setLocalLocation(tz.getLocation("Asia/Tokyo")); //日本標準時の設定
  } catch (error) {
    print('Error initializing Firebase or timezone: $error');
    return; // エラーがあればここで返す
  }

  // 繰り返し処理させるためのタイマー
  // 毎日9時に実行 -> リマインドを設定
  DateTime now = DateTime.now();
  if (now.hour >= 9) {
    await scheduleDailyNotification();
  }
  ;
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  // iOSのバックグラウンド処理
  return true;
}
