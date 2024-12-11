import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('管理者ページ'),
      ),
      body: Center(
        child: const Text('ここは管理者専用ページです。'),
      ),
    );
  }
}