import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'stamp_detail_page.dart';

class FukuPage extends StatefulWidget {
  const FukuPage({super.key});

  @override
  _FukuPageState createState() => _FukuPageState();
}

class _FukuPageState extends State<FukuPage> {
  final List<DateTime?> _stampDates = List.generate(20, (index) => null);

  @override
  void initState() {
    super.initState();
    _loadStampData(); // 起動時に保存されたスタンプ状態をロード
  }

  // スタンプ情報を SharedPreferences からロードする
  Future<void> _loadStampData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 20; i++) {
      String? stampDateString = prefs.getString('stamp_$i');
      if (stampDateString != null) {
        setState(() {
          _stampDates[i] = DateTime.parse(stampDateString);
        });
      }
    }
  }

  // スタンプ情報を SharedPreferences に保存する
  Future<void> _saveStampData(int index, DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('stamp_$index', date.toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sticker sheet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: 20,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (_stampDates[index] == null) {
                    // スタンプを押した時の処理
                    DateTime now = DateTime.now();
                    _stampDates[index] = now;
                    _saveStampData(index, now); // 保存する
                  } else {
                    // すでにスタンプが押されている場合は詳細ページへ遷移
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
                          '${index + 1}',
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
