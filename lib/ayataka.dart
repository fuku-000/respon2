import 'package:flutter/material.dart';

class AyatakaPage extends StatelessWidget {
  const AyatakaPage({super.key});

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

void main() {
  runApp(const MaterialApp(
    home: AyatakaPage(),
  ));
}