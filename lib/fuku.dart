import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'stamp_detail_page.dart';

class FukuPage extends StatefulWidget {
  const FukuPage({
    super.key,
  });

  @override
  _FukuPageState createState() => _FukuPageState();
}

class _FukuPageState extends State<FukuPage> {
  final List<DateTime?> _stampDates = List.generate(20, (index) => null);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userId;

  @override
  void initState() {
    super.initState();
    _loadUser(); // ユーザーのロード
  }

  Future<void> _loadUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      userId = user.uid;
      await _loadStampData(); // スタンプデータをロード
    } else {
      // ユーザーがログインしていない場合のエラーハンドリング
    }
  }

  // スタンプ情報を Firestore からロードする
  Future<void> _loadStampData() async {
    DocumentSnapshot doc = await _firestore
        .collection('Users')
        .doc(userId)
        .collection('stamp')
        .doc('user_stamps')
        .get();
    if (doc.exists) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      for (int i = 0; i < 20; i++) {
        if (data != null && data.containsKey('stamp_$i')) {
          setState(() {
            _stampDates[i] = (data['stamp_$i'] as Timestamp).toDate();
          });
        }
      }
    }
  }

  // スタンプ情報を Firestore に保存する
  Future<void> _saveStampData(int index, DateTime? date) async {
    if (date == null) {
      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('stamp')
          .doc('user_stamps')
          .update({
        'stamp_$index': FieldValue.delete(),
      });
    } else {
      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('stamp')
          .doc('user_stamps')
          .set({
        'stamp_$index': Timestamp.fromDate(date),
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'スタンプページ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: Color(0xFFAFE3B7),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: 20,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  if (_stampDates[index] == null) {
                    DateTime now = DateTime.now();
                    setState(() {
                      _stampDates[index] = now;
                    });
                    await _saveStampData(index, now);
                  } else {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StampDetailPage(
                          stampDate: _stampDates[index]!,
                          stampIndex: index + 1,
                        ),
                      ),
                    );
                    if (result == true) {
                      setState(() {
                        _stampDates[index] = null;
                      });
                      await _saveStampData(index, null);
                    }
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: _stampDates[index] != null
                        ? Colors.teal.withOpacity(0.8)
                        : Colors.greenAccent.withOpacity(0.6),
                    border: Border.all(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _stampDates[index] != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.white, size: 36),
                              const SizedBox(height: 5),
                              Text(
                                DateFormat('MM/dd').format(_stampDates[index]!),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
