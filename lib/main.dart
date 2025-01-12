import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'fuku.dart';
import 'full.dart';
import 'weather.dart';
import 'yuki.dart';
import 'ayataka.dart';
import 'login_function.dart';
import 'notification_service.dart';
import 'back_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/src/platform_specifics/android/initialization_settings.dart';
import 'package:flutter_local_notifications/src/platform_specifics/android/notification_channel.dart';
import 'package:flutter_local_notifications/src/platform_specifics/android/notification_details.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

// ローカル通知用のインスタンスを作成
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// バックグラウンド処理用のハンドラ
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  var taskId = task.taskId;
  var timeout = task.timeout;

  if (timeout) {
    print('[BackgroundFetch] Headless task timed-out: $taskId');
    BackgroundFetch.finish(taskId);
    return;
  }

  print('[BackgroundFetch] Headless event received: $taskId');

  // Firebase初期化（バックグラウンドで必要な場合）
  await Firebase.initializeApp();

  try {
    // makeMessageを呼び出して新しい文章を生成
    //String newContent = await makeMessage();

    // 通知を表示
  } catch (e) {
    print('Error in background task: $e');
    // エラー時のフォールバック通知
  }

  // タスク完了を通知
  BackgroundFetch.finish(taskId);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // タイムゾーンの初期化
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation("Asia/Tokyo")); //日本標準時

  // バックグラウンドサービスの初期化
  await initializeBackgroundService();

  // Firebase初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'daily_channel_id',
    'Daily Notifications',
    description: '毎日特定の時間に通知を送るためのチャンネル',
    importance: Importance.high,
  );

  // 通知の初期化
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(); // iOS用設定を追加
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS, // iOS用設定を統合
  );
  //通知チャンネル設定
  const AndroidNotificationChannel setChannel = AndroidNotificationChannel(
    'daily_channel_id',
    'Daily Notifications',
    description: '毎日特定の時間に通知を送るためのチャンネル',
    importance: Importance.high,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) async {
      // 通知タップ時の処理
      print('Notification tapped: ${details.payload}');
    },
  );
  // チャンネルの作成
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'respon2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFAFE3B7)),
        useMaterial3: true,
      ),
      home: FullPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //requestExactAlarmPermission(); // Android,アプリ起動時に権限をリクエスト
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  /*void requestExactAlarmPermission() async {
    //android
    // Exact アラームの権限を要求
    if (await Permission.scheduleExactAlarm.request().isGranted) {
      // 権限が付与された場合の処理
      print("Exact alarm permission granted.");
    } else {
      // 権限が付与されていない場合の処理
      print("Exact alarm permission denied. Redirecting to settings.");
      openAppSettings(); // 設定画面にリダイレクト
    }
  }*/

  // 認証状態を確認しページに遷移するメソッド
  void _navigateToPageIfAuthenticated(Widget page) {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    } else {
      // 未ログイン時に警告を表示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('このページにアクセスするにはログインが必要です')),
      );
    }
  }

  Future<void> _loginUser() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    // login_function.dartのログイン関数を呼び出し
    bool success = await signupUser(name, email, password);

    if (success) {
      print('アカウント作成に成功しました');
      // ログイン成功時にAyatakaPageへ遷移
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AyatakaPage()),
      );
    } else {
      print('アカウント作成に失敗しました');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // キーボード表示時の調整を有効化
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'ログイン',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '名前',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'メールアドレス',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'パスワード',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginUser,
              child: const Text('ログイン'),
            ),
            const SizedBox(height: 20),
            // プッシュ通知をスケジュールするボタン
            ElevatedButton(
              onPressed: () async {
                await scheduleDailyNotification();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('通知をスケジュールしました！')),
                );
              },
              child: const Text('通知をスケジュール'),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  // 管理者用画面への遷移を実装する
                },
                child: const Text('管理者用はこちら →'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToPageIfAuthenticated(const FukuPage()),
              child: const Text('Fukuページに移動'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToPageIfAuthenticated(FullPage()),
              child: const Text('Fullページに移動'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToPageIfAuthenticated(AyatakaPage()),
              child: const Text('Ayatakaページに移動'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'インクリメント',
        child: const Icon(Icons.add),
      ),
    );
  }
}
