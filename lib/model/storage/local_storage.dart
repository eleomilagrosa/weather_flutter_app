import 'dart:async';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  final storage = GetStorage();
  // Keys
  String kkRefreshToken = 'refresh_token';
  String kkTokenExp = 'token_exp';
  String kkAccessToken = 'access_token';

  Future<bool> clearStorage() async {
    storage.erase();
    return true;
  }

  Future saveToken(String authToken) async {
    await storage.write(kkAccessToken, authToken);
  }

  Future<String> token() async {
    return storage.read(kkAccessToken) ?? "";
  }

  Future saveTokenExp(int exp) async {
    await storage.write(kkTokenExp, exp.toString());
  }

  Future<int> tokenExp() async {
    return int.tryParse(storage.read(kkTokenExp) ?? "0") ?? 0;
  }

  Future saveRefreshToken(String authToken) async {
    await storage.write(kkRefreshToken, authToken);
  }

  Future<String> refreshToken() async {
    return storage.read(kkRefreshToken) ?? "";
  }
}
