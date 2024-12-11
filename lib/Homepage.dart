import 'package:flutter/material.dart';

class AyatakaPage extends StatelessWidget {
  const AyatakaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              '今日の活動予定',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('～～～～～～～～～～～～～～～～～～'),
            const SizedBox(height: 30),
            const Bubble(
              text: 'ひとこと',
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // データベースへの navigation
                  },
                  child: const Text('データベース'),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // カレンダーへ navigation
                      },
                      child: const Text('カレンダーへ'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // スタンプ navigation
                      },
                      child: const Text('スタンプ'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final String text;

  const Bubble({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: CustomPaint(
              size: const Size(20, 20),
              painter: BubbleArrowPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class BubbleArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.lightBlueAccent
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 10)
      ..lineTo(10, 0)
      ..lineTo(20, 10)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  runApp(const MaterialApp(
    home: AyatakaPage(),
  ));
}
