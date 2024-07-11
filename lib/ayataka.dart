import 'package:flutter/material.dart';

class AyatakaPage extends StatelessWidget {
  const AyatakaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> names = ['John Doe', 'Jane Smith', 'Alice Johnson', 'Bob Brown'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayataka Page'),
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
