import 'package:flutter/material.dart';
import 'package:weather_flutter_app/model/weather_forecast.dart';
import 'package:weather_flutter_app/views/widgets/custom_app_bar.dart';

class WeatherPageView extends StatefulWidget {

  final WeatherForecast weatherForecast;
  const WeatherPageView(this.weatherForecast, {Key? key}) : super(key: key);

  @override
  State<WeatherPageView> createState() => _WeatherPageViewState();
}

class _WeatherPageViewState extends State<WeatherPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.buildDefaultAppBar(context, hasOnBackPress: true),
      body: SafeArea(
        child: DataTable(
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
      ),
    );
  }
}
