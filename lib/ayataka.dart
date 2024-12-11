import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:respon2/fuku.dart';
import 'package:respon2/full.dart';
import 'package:respon2/login_function.dart';

class AyatakaPage extends StatefulWidget {
  AyatakaPage({Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<AyatakaPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _loginUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // login_functions.dartのログイン関数を呼び出す
    bool success = await loginUser(email, password);

    if (success) {
      // ログイン成功時の処理
      print('ログイン成功');
      //ホームページへ遷移する処理を書く
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          return FullPage();
        }),
      );
    } else {
      // ログイン失敗時の処理
      print('ログイン失敗');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF70E173), // AppBarの背景色を設定
        title: const Text(''), // 元のコード通り、タイトルは空のままに
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF70E173), // テキストの色を設定
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'メールアドレス',
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF70E173)), // 枠線の色
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF70E173)), // 枠線の色
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'パスワード',
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF70E173)), // 枠線の色
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF70E173)), // 枠線の色
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF70E173), // ボタンの背景色
              ),
              onPressed: () {
                // ログイン処理をここに実装
              },
              onPressed: _loginUser,
              child: const Text(
                'ログイン',
                style: TextStyle(
                  color: Colors.white, // 読みやすさのためにテキスト色は白
                ),
              ),

            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  // 管理者用のナビゲーションをここに実装
                },
                child: const Text(
                  '管理者はこちらから→',
                  style: TextStyle(
                    color: Color(0xFF70E173), // テキストボタンの色
                  ),
                ),
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
