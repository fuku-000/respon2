import 'package:flutter/material.dart';

class FukuPage extends StatelessWidget {
  const FukuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> names = ['落合福', 'Jane Smith', 'Alice Johnson', 'Bob Brown','福澤裕生'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('スタンプカード'),
      ),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(names[index]),
          );
        },
      ),
    );
  }
}
