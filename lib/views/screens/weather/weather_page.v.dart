import 'package:flutter/material.dart';
import 'package:weather_flutter_app/model/weather_forecast.dart';
import 'package:weather_flutter_app/views/widgets/custom_app_bar.dart';

class WeatherPageView extends StatefulWidget {

  final WeatherForecast weatherForecast;
  final String city;
  const WeatherPageView(this.city, this.weatherForecast, {Key? key}) : super(key: key);

  @override
  State<WeatherPageView> createState() => _WeatherPageViewState();
}

class _WeatherPageViewState extends State<WeatherPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.buildDefaultAppBar(context, hasOnBackPress: true),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24,),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(widget.city, style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 12,),
            DataTable(
              columns: const [
                DataColumn(
                    label: Text("Date (mm/dd/yyyy)")
                ),
                DataColumn(
                    label: Text("Temperature (F)")
                ),
              ], rows: [
                DataRow(
                    cells: [
                      DataCell(Text(widget.weatherForecast.dtToDateString)),
                      DataCell(Text(widget.weatherForecast.main?.temp?.toString() ?? "0")),
                    ],
                )
            ],
            ),
          ],
        ),
      ),
    );
  }
}
