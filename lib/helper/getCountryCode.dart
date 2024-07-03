import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Future getCountryCode(double latitude, double longitude) async {
  String country = 'Unknown';
  String apiUrl =
      'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json';
  try {
    final response = await Dio().get(apiUrl);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      debugPrint("response: $data");
      country = data['address']['country_code'] ?? 'Unknown';
      return country;
    }
  } catch (e) {
    debugPrint('Error: $e');
  }
}
