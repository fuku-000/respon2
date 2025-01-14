import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StampDetailPage extends StatelessWidget {
  final DateTime stampDate;
  final int stampIndex;

  const StampDetailPage({
    super.key,
    required this.stampDate,
    required this.stampIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'スタンプ詳細',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // 白い文字色
          ),
        ),
        backgroundColor: const Color(0xFFAFE3B7), // 統一した背景色
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Colors.teal.withOpacity(0.8), // 同じ色のアイコン
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                '番号: $stampIndex',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal, // 統一感のあるテキスト色
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '押した日時:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                DateFormat('yyyy/MM/dd HH:mm:ss').format(stampDate),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  // 確認ポップアップ表示
                  bool confirm = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('確認'),
                        content: const Text('スタンプを取り消しますか？'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('キャンセル'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  // 確認後、取り消し実行
                  if (confirm == true) {
                    Navigator.of(context).pop(true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAFE3B7), // ボタンの背景色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // ボタンの角丸
                  ),
                ),
                child: const Text(
                  'スタンプを取り消す',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // ボタン内の文字色
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
