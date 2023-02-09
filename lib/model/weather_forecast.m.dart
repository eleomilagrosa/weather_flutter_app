import 'package:weather_flutter_app/utils/custom_extensions.dart';

class WeatherForecast {
  int? dt;
  Main? main;

  String get dtToDateString => dt == null ? "" : DateTime.fromMillisecondsSinceEpoch(dt! * 1000).toMMddyyyy();

  WeatherForecast(
      { this.dt,
        this.main,});

  WeatherForecast.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    main = json['main'] != null ? Main.fromJson(json['main']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['dt'] =  dt;
    data['main'] =  main?.toJson();
    return data;
  }
}

class Main {
  double? temp;
  double? feelsLike;
  double? tempMin;
  double? tempMax;


  Main(
      { this.temp,
        this.feelsLike,
        this.tempMin,
        this.tempMax,
        });

  Main.fromJson(Map<String, dynamic> json) {
    temp = json['temp']?.toDouble();
    feelsLike = json['feels_like']?.toDouble();
    tempMin = json['temp_min']?.toDouble();
    tempMax = json['temp_max']?.toDouble();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['temp'] =  temp;
    data['feels_like'] =  feelsLike;
    data['temp_min'] =  tempMin;
    data['temp_max'] =  tempMax;
    return data;
  }
}