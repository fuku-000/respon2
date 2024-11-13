import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 日付フォーマット

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
        title: const Text('details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.pinkAccent, size: 100),
              const SizedBox(height: 20),
              Text(
                'number: $stampIndex',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '押した日時:',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              Text(
                DateFormat('yyyy/MM/dd HH:mm:ss').format(stampDate),
                style: const TextStyle(fontSize: 18),
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
                child: const Text('スタンプを取り消す'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
