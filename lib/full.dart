import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'weather.dart'; // WeatherPage が定義されたファイルをインポート

class FullPage extends StatefulWidget {
  @override
  _FullPageState createState() => _FullPageState();
}

class _FullPageState extends State<FullPage> {
  DateTime selectedDate = DateTime.now();
  Map<DateTime, bool> attendance = {}; // 出欠データを保存するマップ

  // 出欠確認機能：その日の日付に出欠をトグル
  void toggleAttendance(DateTime date) {
    setState(() {
      attendance[date] = !(attendance[date] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('カレンダーと出欠確認'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
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
            calendarBuilders: CalendarBuilders(
              // カレンダーの日付に応じて出欠情報を表示
              defaultBuilder: (context, day, focusedDay) {
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: attendance[day] == true
                          ? Colors.green.withOpacity(0.5) // 出席：緑
                          : Colors.red.withOpacity(0.5), // 欠席：赤
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Text(day.day.toString()),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            "選択した日: ${selectedDate.toLocal()}".split(' ')[0],
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              // 選択した日に対して出欠をトグル
              toggleAttendance(selectedDate);
            },
            child: Text(
              attendance[selectedDate] == true ? '出席 → 欠席に変更' : '欠席 → 出席に変更',
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // 天気情報ページに選択した日付を渡して遷移
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeatherPage(selectedDate: selectedDate),
                ),
              );
            },
            child: Text('天気情報を見る'),
          ),
        ],
      ),
    );
  }
}
