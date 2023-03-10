import 'package:flutter/material.dart';
import 'package:weather_flutter_app/model/service/weather.s.dart';
import 'package:weather_flutter_app/model/weather_forecast.m.dart';
import 'package:weather_flutter_app/view_model/auth.vm.dart';
import 'package:collection/collection.dart';

class WeatherViewModel extends ChangeNotifier {

  WeatherService weatherService = WeatherService();
  final AuthViewModel _authViewModel;

  WeatherViewModel(this._authViewModel);

  bool loadingWeatherForecast = false;
  Future<WeatherForecast?> getWeatherForecastByCityName(String cityName)async{
    loadingWeatherForecast = true;
    notifyListeners();
    try{
      var weatherForecasts = await weatherService.getWeatherForecastByCityName(cityName);
      loadingWeatherForecast = false;
      notifyListeners();
      return weatherForecasts.firstOrNull;
    }catch(e,trace){
      loadingWeatherForecast = false;
      notifyListeners();
      rethrow;
    }
  }
}