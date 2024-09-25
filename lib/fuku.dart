import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 日付フォーマットのために必要
import 'stamp_detail_page.dart'; // 詳細ページのインポート

class FukuPage extends StatefulWidget {
  const FukuPage({super.key});

  @override
  _FukuPageState createState() => _FukuPageState();
}

class _FukuPageState extends State<FukuPage> {
  // スタンプが押された日時を保存するリスト (押されてない場合は null)
  final List<DateTime?> _stampDates = List.generate(20, (index) => null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('スタンプカード (ポップなデザイン)'),
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
                  if (_stampDates[index] == null) {
                    // スタンプを押した時、現在の日時を保存
                    _stampDates[index] = DateTime.now();
                  } else {
                    // すでに押されていた場合、詳細ページへ遷移
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StampDetailPage(
                          stampDate: _stampDates[index]!,
                          stampIndex: index + 1,
                        ),
                      ),
                    );
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: _stampDates[index] != null
                      ? Colors.pinkAccent.withOpacity(0.8)
                      : Colors.lightBlueAccent.withOpacity(0.6),
                  border: Border.all(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: const Offset(2, 2),
                    )
                  ],
                ),
                child: Center(
                  child: _stampDates[index] != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Colors.white, size: 36),
                            const SizedBox(height: 5),
                            Text(
                              // 押された日時をフォーマットして表示
                              DateFormat('MM/dd\nHH:mm').format(_stampDates[index]!),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
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
