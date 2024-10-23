import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'weather.dart'; // weather.dartから天気データを取得するメソッドをインポート
import 'package:intl/intl.dart'; // これを追加


class FullPage extends StatefulWidget {
  @override
  _FullPageState createState() => _FullPageState();
}

class _FullPageState extends State<FullPage> {
  DateTime selectedDate = DateTime.now();
  Map<DateTime, bool> attendance = {}; // 出欠データを保存するマップ
  bool isLoading = false; // 天気データのロード中かどうか
  String? errorMessage; // エラーメッセージ用
  var weatherData; // 取得した天気データを格納する変数

  // 出欠確認機能：その日の日付に出欠をトグル
  void toggleAttendance(DateTime date) {
    setState(() {
      attendance[date] = !(attendance[date] ?? false);
    });
  }

  // 天気データを取得するメソッド
  Future<void> updateWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // 天気データ取得ロジックを呼び出す（都市名は「Tokyo」を指定）
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
  void initState() {
    super.initState();
    updateWeather(); // 初期状態で天気データを取得
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale=Localizations.localeOf(context).toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('カレンダーと出欠確認'),
        actions:[]
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // カレンダー部分
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: selectedDate,
            headerVisible: false,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
                updateWeather(); // 日付選択時に天気情報を更新
              });
            },
          ),
          SizedBox(height: 20.0),
          Text("選択した日: ${DateFormat('yyyy年MM月dd日').format(selectedDate)}",
          style: TextStyle(fontSize: 20),
          ),

          
          SizedBox(height: 20.0),

          // 天気情報の表示部分
          isLoading
              ? CircularProgressIndicator() // ローディング中はスピナーを表示
              : errorMessage != null
                  ? Text(errorMessage!) // エラーメッセージを表示
                  : weatherData != null
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '都市: ${weatherData['city']['name']}',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '気温: ${weatherData['list'][0]['main']['temp']} °C',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '天気: ${weatherData['list'][0]['weather'][0]['description']}',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '風速: ${weatherData['list'][0]['wind']['speed']} m/s',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '湿度: ${weatherData['list'][0]['main']['humidity']}%',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        )
                      : Text('天気データがありません'),
        ],
      ),
    );
  }
}
