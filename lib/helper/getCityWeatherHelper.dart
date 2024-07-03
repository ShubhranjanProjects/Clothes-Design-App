import 'dart:convert';

import 'package:countries_of_the_world/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Future getCityWeather(String capital) async {
  String weatherUrl = 'https://api.openweathermap.org/data/2.5/weather';
  const apiKey = OpenWeatherAPIKey;
  String apiUrl = '$weatherUrl?q=$capital&appid=$apiKey&units=metric';

  try {
    final response = await Dio().get(apiUrl);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      debugPrint("response: $data");
      return data;
    } else {
      throw Exception('Failed to fetch weather data');
    }
  } catch (e) {
    debugPrint('Error: $e');
    // Handle error
  }
}

// Future<String> _getWeather(String capital) async {
//   try {
//     http.Response response = await http.get(Uri.parse(apiUrl));
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       double temp = data['main']['temp'];
//       String weatherDescription = data['weather'][0]['description'];
//       return 'Temperature: $temp°C\nWeather: $weatherDescription';
//     } else {
//       return 'Failed to load weather data';
//     }
//   } catch (e) {
//     return 'Error fetching weather data: $e';
//   }
// }
