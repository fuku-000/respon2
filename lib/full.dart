
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';



void main() async {
  var url = Uri.parse('https://jsonplaceholder.typicode.com/todos/1');
  var response = await http.get(url);
  
  if (response.statusCode == 200) {
    print('Response data: ${response.body}');
  } else {
    print('Request failed with status: ${response.statusCode}');
  }
}
class FullPage extends StatelessWidget {
  const FullPage({Key? key}) : super(key: key);
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'カレンダーアプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarPage(),
    );
  }
}

  

/*
  @override
  Widget build(BuildContext content) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("mahiro"),
      ),
      body: Center(
        child: Text(overflow: TextOverflow.fade, maxLines: 1, 'mahiro'),
      ),
    );
  }
}
*/

/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'カレンダーアプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarPage(),
    );
  }
}
*/

// MyAppクラスを定義


// 天気情報を取得する関数
Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
  final apiKey = '812e77b899354f40bf691831242509'; // OpenWeatherMapのAPIキー
  final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load weather');
  }
}

// 天気表示用のウィジェット
class WeatherWidget extends StatelessWidget {
  final double lat;
  final double lon;

  WeatherWidget({required this.lat, required this.lon});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchWeather(lat, lon),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final weather = snapshot.data!;
          return Column(
            children: [
              Text('天気: ${weather['weather'][0]['description']}'),
              Text('温度: ${weather['main']['temp']} °C'),
            ],
          );
        }
      },
    );
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, String> _memos = {};

  /*
  // 天気APIから天気情報を取得する関数
  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    final apiKey = '812e77b899354f40bf691831242509';  // OpenWeatherMapのAPIキーをここに入力
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather');
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('カレンダー'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              
              // メモページに遷移
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MemoPage(
                    selectedDay: _selectedDay,
                    memo: _memos[_selectedDay] ?? '',
                    onSave: (String memo) {
                      setState(() {
                        _memos[_selectedDay] = memo;
                      });
                    },
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          WeatherWidget(lat: 35.68, lon: 139.76),  // 東京の緯度経度（任意で変更可能）
        ],
      ),
    );
  }
}

/*
class WeatherWidget extends StatelessWidget {
  final double lat;
  final double lon;

  WeatherWidget({required this.lat, required this.lon});

  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    final apiKey = 'Y812e77b899354f40bf691831242509';  // OpenWeatherMapのAPIキーを入力
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather');
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchWeather(lat, lon),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final weather = snapshot.data!;
          return Column(
            children: [
              Text('天気: ${weather['weather'][0]['description']}'),
              Text('温度: ${weather['main']['temp']} °C'),
            ],
          );
        }
      },
    );
  }
}
*/


class MemoPage extends StatefulWidget {
  final DateTime selectedDay;
  final String memo;
  final Function(String) onSave;

  MemoPage({
    required this.selectedDay,
    required this.memo,
    required this.onSave,
  });

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  late TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController(text: widget.memo);
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メモ (${widget.selectedDay.toLocal()})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _memoController,
              decoration: InputDecoration(
                labelText: 'メモを入力してください',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onSave(_memoController.text);
                Navigator.pop(context);
              },
              child: Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}


