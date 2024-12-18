import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'main.dart';

Future<void> scheduleDailyNotification() async {
  // 通知内容を設定
  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails('daily_channel_id', 'Daily Notifications',
          channelDescription: '毎日特定の時間に通知を送るためのチャンネル',
          importance: Importance.high,
          priority: Priority.high);
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  // 毎日特定の時間にスケジュール
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0, // 通知ID
    'お知らせ', // 通知のタイトル
    '今日は何か忘れていませんか？', // 通知の内容
    _nextInstanceOfSpecificTime(9, 0), // 毎朝9時にスケジュール
    notificationDetails,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time, // 時間だけを毎日マッチ
  );
}

// 特定の時間を設定するヘルパー関数
tz.TZDateTime _nextInstanceOfSpecificTime(int hour, int minute) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}
