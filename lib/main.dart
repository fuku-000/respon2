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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      home: const MyHomePage(title: 'Stamp Card'),
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

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
