import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:respon2/fuku.dart';
import 'package:respon2/full.dart';
import 'package:respon2/ayataka.dart';
import 'package:respon2/login_function.dart';

class yukiPage extends StatefulWidget {
  yukiPage({Key? key}) : super(key: key);

  @override
  _createAccountPage createState() => _createAccountPage();
}

class _createAccountPage extends State<yukiPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _loginUser() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    // login_functions.dartのログイン関数を呼び出す
    bool success = await signupUser(name, email, password);

    if (success) {
      // ログイン成功時の処理
      print('アカウント作成成功');
      //ホームページへ遷移する処理を書く
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          return AyatakaPage();
        }),
      );
    } else {
      // ログイン失敗時の処理
      print('アカウント作成失敗');
    }
  }

  void test1() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        getName();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // スキャフォールドのタイトルを削除
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'アカウント作成',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '名前',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'メールアドレス',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'パスワード',
                border: OutlineInputBorder(),
              ),
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
                  test1();
                },
                child: const Text('管理者はこちらから→'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*void main() {
  runApp(const MaterialApp(
    home: AyatakaPage(),
  ));
}*/
