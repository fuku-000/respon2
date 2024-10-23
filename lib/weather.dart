import 'dart:convert';
import 'package:http/http.dart' as http;

// 天気データを取得するメソッドを定義
Future<Map<String, dynamic>> fetchWeatherData(String city) async {
  String apiKey = 'f88e1f45993ac79690b78efe060c5460'; // OpenWeatherMapのAPIキーを入力

  final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load weather data');
  }
}

