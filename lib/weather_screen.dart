import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wearther_app/additional_info_item.dart';
import 'package:wearther_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
    // Load the .env file
    await dotenv.load(fileName: ".env");
    // Read the key
    String? apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    String cityName = 'London';

    try {
      final res = await http.get(
        Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$apiKey',
        ),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }

      setState(() {
        temp = data['list'][0]['main']['temp'];
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather app',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: temp == 0
          ? const CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // main card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '$temp K',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Icon(Icons.cloud, size: 64),
                                const SizedBox(height: 16),
                                const Text(
                                  'Rain',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Weather Forecast',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // weather forcast cards
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        HourlyForcastItem(
                          time: '00:00',
                          icon: Icons.cloud,
                          temperature: '301.22',
                        ),
                        HourlyForcastItem(
                          time: '03:00',
                          icon: Icons.sunny,
                          temperature: '300.52',
                        ),
                        HourlyForcastItem(
                          time: '06:00',
                          icon: Icons.cloud,
                          temperature: '300.12',
                        ),
                        HourlyForcastItem(
                          time: '09:00',
                          icon: Icons.sunny,
                          temperature: '301.22',
                        ),
                        HourlyForcastItem(
                          time: '12:00',
                          icon: Icons.cloud,
                          temperature: '304.12',
                        ),
                      ],
                    ),
                  ),

                  // additional information
                  const SizedBox(height: 20),
                  const Text(
                    'Additional Information',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: '91',
                      ),
                      AdditionalInfoItem(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: '7.5',
                      ),
                      AdditionalInfoItem(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: '1000',
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
