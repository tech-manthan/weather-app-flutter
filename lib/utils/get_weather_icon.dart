import 'package:flutter/material.dart';

IconData getWeatherIcon(String weatherName) {
  if (weatherName == "Clouds" || weatherName == "Rain") {
    return Icons.cloud;
  } else {
    return Icons.sunny;
  }
}
