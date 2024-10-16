import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  final DateTime selectedDate;  // カレンダーから渡された日付を受け取る

  WeatherPage({required this.selectedDate});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String apiKey = 'f88e1f45993ac79690b78efe060c5460';  // OpenWeatherMapのAPIキーをここに入力
  String city = 'Tokyo';  // 任意の都市名
  var weatherData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  // 天気データを取得するメソッド
  Future<void> fetchWeatherData() async {
  setState(() {
    isLoading = true;
    errorMessage = '';
  });

  final url = Uri.parse(
    'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric');

  try {
    final response = await http.get(url);
    debugPrint("point0");
    if (response.statusCode == 200) {
      debugPrint(response.body); // APIレスポンスの内容を確認
      setState(() {
        weatherData = json.decode(response.body);
        debugPrint("point1");
        isLoading = false;
        
      });
    } else {
      setState(() {
        errorMessage = '天気データの取得に失敗しました（ステータスコード: ${response.statusCode}）';
        debugPrint("point2");
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      errorMessage = 'エラーが発生しました: $e';
      debugPrint("point3");
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('天気情報 (${widget.selectedDate.toLocal()}'.split(' ')[0] + ')'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage)) // エラーメッセージを表示
              : weatherData == null
                  ? Center(child: Text('データがありません'))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
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
                      ),
                    ),
    );
  }
}


