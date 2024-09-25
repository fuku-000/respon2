import 'package:flutter/material.dart';

class FukuPage extends StatefulWidget {
  const FukuPage({super.key});

  @override
  _FukuPageState createState() => _FukuPageState();
}

class _FukuPageState extends State<FukuPage> with SingleTickerProviderStateMixin {
  // スタンプが押されているかどうかを管理するリスト
  final List<bool> _isStamped = List.generate(20, (index) => false);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ポップなスタンプカード'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, // 5列のグリッド
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: 20,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  // タップされたマスのスタンプ状態をトグルする
                  _isStamped[index] = !_isStamped[index];
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300), // アニメーションの長さ
                curve: Curves.easeInOut, // スムーズなアニメーション
                decoration: BoxDecoration(
                  color: _isStamped[index]
                      ? Colors.pinkAccent.withOpacity(0.8) // 押された時はポップなピンク色
                      : Colors.lightBlueAccent.withOpacity(0.6), // 未押時は明るいブルー
                  border: Border.all(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: const Offset(2, 2), // 影を少しだけ追加
                    )
                  ],
                ),
                child: Center(
                  child: _isStamped[index]
                      ? const Icon(Icons.star, color: Colors.white, size: 36) // スタンプ後は星マーク
                      : Text(
                          '${index + 1}', // マスの番号を表示
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
