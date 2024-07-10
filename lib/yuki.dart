import 'package:flutter/material.dart';

class yukiPage extends StatelessWidget {
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
