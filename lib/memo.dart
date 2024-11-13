import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class FullPage extends StatefulWidget {
  @override
  _FullPageState createState() => _FullPageState();
}

class _FullPageState extends State<FullPage> {
  DateTime selectedDate = DateTime.now();
  Map<DateTime, String> notes = {}; // 日付ごとのメモを保持するマップ
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNotes(); // 保存されたメモをロード
  }


  // メモの保存
  Future<void> saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // notesマップをJSON文字列に変換して保存
    Map<String, String> notesStringMap = notes.map((key, value) =>
      MapEntry(DateFormat('yyyy-MM-dd').format(key), value));
    String encodedNotes = jsonEncode(notesStringMap); // JSON文字列に変換
    await prefs.setString('notes', encodedNotes);
  }

  // メモのロード
  Future<void> loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedNotes = prefs.getString('notes');
    if (savedNotes != null) {
      // JSON文字列をMapに変換して読み込む
      Map<String, dynamic> decodedNotes = jsonDecode(savedNotes);
      setState(() {
        notes = decodedNotes.map((key, value) =>
          MapEntry(DateFormat('yyyy-MM-dd').parse(key), value.toString()));
      });
    }
  }

  // メモを入力するためのダイアログを表示
  void showNoteDialog() {
    noteController.text = notes[selectedDate] ?? '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('メモを入力'),
          content: TextField(
            controller: noteController,
            maxLines: 3,
            decoration: InputDecoration(hintText: "ここにメモを入力"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  notes[selectedDate] = noteController.text;
                });
                saveNotes(); // メモを保存
                Navigator.of(context).pop();
              },
              child: Text('保存'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('カレンダーとメモ'),
        actions: [],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // カレンダー部分
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: selectedDate,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
              });
            },
          ),
          SizedBox(height: 20.0),
          Text("選択した日: ${DateFormat('yyyy年MM月dd日').format(selectedDate)}",
              style: TextStyle(fontSize: 20)),
          SizedBox(height: 20.0),
          
          // メモ追加ボタン
          ElevatedButton(
            onPressed: showNoteDialog,
            child: Text("メモを追加"),
          ),
          SizedBox(height: 20.0),

          // 選択された日付のメモの表示
          Text(
            notes[selectedDate] ?? 'メモがありません',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}


