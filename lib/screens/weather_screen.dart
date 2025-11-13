import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/components/additional_info_item.dart';
import 'package:weather_app/components/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';
import 'package:weather_app/utils/get_weather_icon.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    const cityName = "Dehradun";
    try {
      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApiKey",
        ),
      );
      final data = jsonDecode(res.body);

      if (data["cod"] != "200") {
        throw Exception("An Unexpected error occured");
      }

      return data;
      // print(data["list"][0]["main"]["temp"]);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(
              Icons.refresh,
              size: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                spacing: 10,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Error",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.justify,
                    snapshot.error.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    "Try Refreshing!!!",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!;
          final currentWeatherData = data["list"][0];
          final currentTemp = currentWeatherData["main"]["temp"];
          final currentWeather = currentWeatherData["weather"][0]["main"];
          final humidity = currentWeatherData["main"]["humidity"];
          final pressure = currentWeatherData["main"]["pressure"];
          final windSpeed = currentWeatherData["wind"]["speed"];

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadiusGeometry.all(
                      Radius.circular(20),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              "$currentTemp°K",
                              style: const TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Icon(
                              getWeatherIcon(currentWeather),
                              size: 80,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              currentWeather.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Hourly Forecast",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    wordSpacing: 2,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     spacing: 8,
                //     children: [
                //       for (int i = 0; i < 5; i++)
                //         HourlyForecastItem(
                //           icon: getWeatherIcon(
                //             data["list"][i + 1]["weather"][0]["main"],
                //           ),
                //           time: data["list"][i + 1]["dt"].toString(),
                //           temperature: data["list"][i + 1]["main"]["temp"]
                //               .toString(),
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 140,

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyForcast = data["list"][index + 1];
                      final time = DateTime.parse(hourlyForcast["dt_txt"]);
                      final weather = hourlyForcast["weather"][0]["main"];
                      final temp = hourlyForcast["main"]["temp"].toString();
                      return HourlyForecastItem(
                        time: DateFormat.j().format(time),
                        icon: getWeatherIcon(
                          weather,
                        ),
                        temperature: temp,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    wordSpacing: 2,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: humidity.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: windSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: pressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
