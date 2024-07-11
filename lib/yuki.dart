import 'package:flutter/material.dart';

class YukiPage extends StatelessWidget {
  const YukiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext content) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("yuki"),
      ),
      body: Center(
        child: Text(overflow: TextOverflow.fade, maxLines: 1, 'Yuki'),
      ),
    );
  }
}
