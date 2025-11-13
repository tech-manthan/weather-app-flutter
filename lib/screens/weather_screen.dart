import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/components/additional_info_item.dart';
import 'package:weather_app/components/hourly_forecast_item.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
            onPressed: () {},
            icon: const Icon(
              Icons.refresh,
              size: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
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
                    child: const Column(
                      children: [
                        Text(
                          "300.67°K",
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Icon(
                          Icons.cloud,
                          size: 80,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Rain",
                          style: TextStyle(
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
              "Weather Forecast",
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
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8,
                children: [
                  HourlyForecastItem(
                    icon: Icons.cloud,
                    time: "00:00",
                    temperature: "301.22",
                  ),
                  HourlyForecastItem(
                    icon: Icons.sunny,
                    time: "03:00",
                    temperature: "304.34",
                  ),
                  HourlyForecastItem(
                    icon: Icons.cloud,
                    time: "06:00",
                    temperature: "345.2",
                  ),
                  HourlyForecastItem(
                    icon: Icons.sunny,
                    time: "09:00",
                    temperature: "322",
                  ),
                  HourlyForecastItem(
                    icon: Icons.sunny_snowing,
                    time: "12:00",
                    temperature: "279.2",
                  ),
                  HourlyForecastItem(
                    icon: Icons.cloud,
                    time: "15:00",
                    temperature: "300",
                  ),
                ],
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
            const Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInfoItem(
                  icon: Icons.water_drop,
                  label: "Humidity",
                  value: "94",
                ),
                AdditionalInfoItem(
                  icon: Icons.air,
                  label: "Wind Speed",
                  value: "6.67",
                ),
                AdditionalInfoItem(
                  icon: Icons.beach_access,
                  label: "Pressure",
                  value: "1005",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
