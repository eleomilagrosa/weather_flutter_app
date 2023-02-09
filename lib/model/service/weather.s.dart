import 'dart:convert';

import 'package:weather_flutter_app/constants/constant.dart';
import 'package:weather_flutter_app/model/service/api.s.dart';
import 'package:weather_flutter_app/model/weather_forecast.dart';
import 'package:weather_flutter_app/utils/printWhenDebug.dart';

class WeatherService{
   ApiService apiService = ApiService(Constant.weatherBaseUrl);

   Future<List<WeatherForecast>> getWeatherForecastByCityName(String cityName)async{
     var response = await apiService.dio.get("/2.5/forecast",
         queryParameters: {
           'q': cityName,
           'appId': Constant.weatherAPIKey,
           'units': "imperial"
         });
     var json = response.data;
     if((json["list"] as List?)?.isNotEmpty ?? false){
       return (json["list"] as List?)?.map((e) => WeatherForecast.fromJson(e)).toList() ?? [];
     }
     return [];
   }
}