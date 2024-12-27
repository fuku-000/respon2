import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

Future<void> scheduleDailyNotification() async {
  // 通知内容を設定
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_channel_id', 'Daily Notifications',
      channelDescription: '毎日特定の時間に通知を送るためのチャンネル',
      importance: Importance.high,
      priority: Priority.high);
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  // Pythonサーバから通知する文章を取得
  //String notificationContent = await makeMessage();

  // 毎日特定の時間にスケジュール
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // 通知ID
      'お知らせ', // 通知のタイトル
      '少女思考中...', // 通知の内容
      _nextInstanceOfSpecificTime(12, 7), // 毎朝9時にスケジュール
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // 時間だけを毎日マッチ
      payload:
          DateFormat('yyyy-MM-dd').format(DateTime.now()) // 日付情報をペイロードとして渡す
      );
}

Future<void> showScheduledNotification(int hour, int minite) async {
  String message = await makeMessage();

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_channel_id', 'Daily Notifications',
      channelDescription: '毎日特定の時間に通知を送るためのチャンネル',
      importance: Importance.high,
      priority: Priority.high);
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  //通知を表示
  await flutterLocalNotificationsPlugin.show(
      0, 'お知らせ', message, notificationDetails,
      payload: jsonEncode({'content': message}));
}

// 特定の時間を設定するヘルパー関数
tz.TZDateTime _nextInstanceOfSpecificTime(int hour, int minute) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  // スケジュールされている時間にメッセージを取得するためのコールバック
  Future.delayed(scheduledDate.difference(now), () async {
    await showScheduledNotification(hour, minute);
  });
  print("settime--------------");
  print(scheduledDate); //デバック用
  print("↓nowtime------------");
  print(tz.TZDateTime(
      tz.local, now.year, now.month, now.day, now.hour, now.minute));

  return scheduledDate;
}

Future<String> makeMessage() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateTime now = DateTime.now();
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day);

  // DateFormatを使用してyyyy-MM-dd形式に変換
  String formattedDate = DateFormat('yyyy-MM-dd').format(scheduledDate);
  User? user = _auth.currentUser;

  print('Current user: ${user?.uid}'); // デバッグ用

  if (user == null) {
    print('No user is currently logged in.');
    throw Exception('User is not logged in.');
  }
  String? textb;
  try {
    //firestoreから今日のメモを取得
    final docSnapshot = await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Notes')
        .doc(formattedDate)
        .get();

    if (docSnapshot.exists) {
      textb = docSnapshot.data()?['content'] ?? ''; // contentフィールドを取得
      print('Fetched textb: $textb'); // デバッグ用
    } else {
      //メモがない場合はそのまま、
      print('Document does not exist for the given time.');
      textb = '';
    }
  } catch (e) {
    print('Error fetching Firestore data: $e');
    throw Exception('Failed to fetch data from Firestore.');
  }

  try {
    //Pythonサーバにアクセス
    final response = await http.post(
      Uri.parse('https://back-respon2.onrender.com//message'),
      headers: {'content-type': 'application/json'},
      body: json.encode({'content': textb}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
      return data['reply']; // 正常なレスポンスの処理
    } else {
      print('Server responded with status code: ${response.statusCode}');
      throw Exception('Failed to send message to the server.');
    }
  } catch (e) {
    print('Error sending HTTP request: $e');
    throw Exception('Failed to send message to server.');
  }
}
