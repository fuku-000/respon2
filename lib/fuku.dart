import 'package:flutter/material.dart';

class FukuPage extends StatefulWidget {
  const FukuPage({super.key});

  @override
  _FukuPageState createState() => _FukuPageState();
}

class _FukuPageState extends State<FukuPage> {
  final List<String> names = ['落合福', 'Jane Smith', 'Alice Johnson', 'Bob Brown', '福澤裕生'];
  
  // 各リスト項目にスタンプが押されているかどうかを管理するリスト
  final List<bool> _isStamped = [false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('スタンプカード'),
      ),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(names[index]),
            trailing: _isStamped[index] 
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.radio_button_unchecked),
            onTap: () {
              setState(() {
                // 押された項目のスタンプ状態をトグルする
                _isStamped[index] = !_isStamped[index];
              });
            },
          );
        },
      ),
    );
  }
}
