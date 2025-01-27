import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'weather.dart'; // 天気データを取得するメソッドをインポート
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:respon2/fuku.dart';
import 'main.dart';
import 'notification_service.dart';

class FullPage extends StatefulWidget {
  @override
  _FullPageState createState() => _FullPageState();
}

class _FullPageState extends State<FullPage> {
  DateTime selectedDate = DateTime.now();
  String get selectedNote =>
      DateFormat('yyyy-MM-dd').format(selectedDate); // selectedNoteを追加
  Map<DateTime, String> notes = {}; // 日付ごとのメモを保持するマップ
  Map<String, String> note = {};
  TextEditingController noteController = TextEditingController();
  bool isLoading = false; // 天気データのロード中かどうか
  String? errorMessage; // エラーメッセージ用
  var weatherData; // 取得した天気データを格納する変数
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadNotes(); // 保存されたメモをロード
    updateWeather(); // 初期状態で天気データを取得
  }

  // メモの保存
  Future<void> saveNotes(DateTime date, String content) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('Users')
          .doc(user.uid)
          .collection('Notes')
          .doc(DateFormat('yyyy-MM-dd').format(date))
          .set({
        'content': content,
      });
    }
  }

//メモの読み込み
  Future<void> loadNotes() async {
    User? user = _auth.currentUser;
    print('Current user: ${user?.uid}'); // デバッグ用
    if (user != null) {
      try {
        QuerySnapshot snapshot = await _firestore
            .collection('Users')
            .doc(user.uid)
            .collection('Notes')
            .get();

        setState(() {
          note = {}; // 既存のメモをクリア
          for (var doc in snapshot.docs) {
            DateTime date = DateFormat('yyyy-MM-dd').parse(doc.id);
            DateTime formatdate = DateTime(date.year, date.month, date.day);
            String docIdFormatted = DateFormat('yyyy-MM-dd').format(formatdate);
            note[docIdFormatted] = doc['content'];
            print(docIdFormatted);
          }
        });
        print('Notes loaded: $note'); // デバッグ用
      } catch (e) {
        print('Error loading notes: $e'); // エラー情報を表示
      }
    } else {
      print('No user is currently logged in.'); // ユーザーがログインしていない場合
    }
  }

  // メモを入力するためのダイアログを表示
  void showNoteDialog() {
    noteController.text =
        note[DateFormat('yyyy-MM-dd').format(selectedDate)] ?? '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text('メモを入力 (${DateFormat('yyyy年MM月dd日').format(selectedDate)})'),
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
                saveNotes(selectedDate, noteController.text); // メモを保存
                scheduleDailyNotification(); // メモをもとにスケジューリング
                loadNotes();
                Navigator.of(context).pop();
              },
              child: Text('保存'),
            ),
          ],
        );
      },
    );
  }

  // 天気データを取得するメソッド
  Future<void> updateWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      var data = await fetchWeatherData("Tokyo");
      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = '天気データの取得に失敗しました: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = Localizations.localeOf(context).toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'カレンダーと出欠確認',
          style: TextStyle(
            fontSize: 20, // フォントサイズ
            fontWeight: FontWeight.bold, // 太字
            color: const Color.fromARGB(255, 255, 255, 255), // テキストの色
          ),
        ),
        backgroundColor: Color(0xFFAFE3B7), // AppBar の背景色
        centerTitle: true, // タイトルを中央揃え
      ),
      body: SingleChildScrollView(
        // スクロール可能にする
        child: Padding(
          padding: const EdgeInsets.all(16.0), // 余白を追加
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // 中央揃えに調整
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
                    //selectedNote = selectedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  todayDecoration: BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFAFE3B7),
                  ),
                  leftChevronIcon: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFFAFE3B7),
                  ),
                  rightChevronIcon: Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFAFE3B7),
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    // 土曜日
                    if (day.weekday == DateTime.saturday) {
                      return Center(
                        child: Text(
                          '${day.day}',
                          style:
                              TextStyle(color: Color(0xFF5569AB)), // 土曜日のスタイル
                        ),
                      );
                    }
                    // 日曜日
                    if (day.weekday == DateTime.sunday) {
                      return Center(
                        child: Text(
                          '${day.day}',
                          style:
                              TextStyle(color: Color(0xFFB51212)), // 日曜日のスタイル
                        ),
                      );
                    }
                    // 他の日
                    return null;
                  },
                ),
              ),

              SizedBox(height: 20.0),
              Text(
                "選択した日: ${DateFormat('yyyy年MM月dd日').format(selectedDate)}",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20.0),
              // メモ追加ボタン
              ElevatedButton(
                onPressed: showNoteDialog,
                child: Text("メモを追加"),
              ),
              SizedBox(height: 20.0),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FukuPage()),
                  );
                },
                child: Text("スタンプページへ"),
              ),
              SizedBox(height: 20.0),

              // 選択された日付のメモの表示
              Text(
                note[selectedNote] ?? 'メモがありません',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20.0),

              // 天気情報の表示部分
              isLoading
                  ? CircularProgressIndicator()
                  : errorMessage != null
                      ? Center(child: Text(errorMessage!))
                      : weatherData != null
                          ? Center(
                              // Wrap the Column with Center
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize
                                    .min, // Adjust size to wrap content
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.location_city,
                                          color: Colors.blue),
                                      SizedBox(width: 8),
                                      Text(
                                        '都市: ${weatherData['city']['name']}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.thermostat,
                                          color: Colors.orange),
                                      SizedBox(width: 8),
                                      Text(
                                        '気温: ${weatherData['list'][0]['main']['temp']} °C',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.wb_sunny, color: Colors.green),
                                      SizedBox(width: 8),
                                      Text(
                                        '天気: ${weatherData['list'][0]['weather'][0]['description']}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.air, color: Colors.purple),
                                      SizedBox(width: 8),
                                      Text(
                                        '風速: ${weatherData['list'][0]['wind']['speed']} m/s',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.water_drop,
                                          color: Colors.brown),
                                      SizedBox(width: 8),
                                      Text(
                                        '湿度: ${weatherData['list'][0]['main']['humidity']}%',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Center(child: Text('天気データがありません')),
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    // アカウント画面への遷移処理
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(title: 'Login')),
                    );
                  },
                  child: const Text('アカウント'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
