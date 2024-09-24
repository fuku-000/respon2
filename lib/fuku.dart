import 'package:flutter/material.dart';

class FukuPage extends StatefulWidget {
  const FukuPage({super.key});

  @override
  _FukuPageState createState() => _FukuPageState();
}

class _FukuPageState extends State<FukuPage> {
  // スタンプが押されているかどうかを管理するリスト
  final List<bool> _isStamped = List.generate(20, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('すごろくスタンプカード'),
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
              child: Container(
                decoration: BoxDecoration(
                  color: _isStamped[index] ? Colors.green : Colors.grey[300],
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: _isStamped[index]
                      ? const Icon(Icons.check, color: Colors.white, size: 30)
                      : Text(
                          '${index + 1}', // マスの番号を表示
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
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
