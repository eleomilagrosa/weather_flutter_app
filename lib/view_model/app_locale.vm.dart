import 'dart:convert';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:weather_flutter_app/model/city.m.dart';
import 'package:weather_flutter_app/model/storage/local_storage.dart';
import 'package:weather_flutter_app/utils/printWhenDebug.dart';

class AppLocaleViewModel extends ChangeNotifier {

  Auth0 auth0 = Auth0('eleom.auth0.com', 'cssM6jWckvweaIxrlI4dtnUgcA1r7wcj');
  LocalStorage localStorage = LocalStorage();

  Credentials? credentials;
  bool loadingLogin = false;
  Future<bool> initiateLogin()async{
    if(loadingLogin) return false;
    try{
      loadingLogin = true;
      notifyListeners();

      credentials = await auth0.webAuthentication(scheme: "https").login();
      printWhenDebug(credentials?.toMap().toString() ?? "");

      loadingLogin = false;
      notifyListeners();
      return true;
    }catch(e,trace){
      loadingLogin = false;
      notifyListeners();
      printWhenDebug([e,trace]);
    }
    return false;
  }

  Future logout()async{
    // await auth0.webAuthentication(scheme: "https").logout();
    credentials = null;
    await localStorage.clearStorage();
  }
}