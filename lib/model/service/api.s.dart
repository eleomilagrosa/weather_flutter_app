import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_flutter_app/model/storage/local_storage.dart';
import 'package:weather_flutter_app/utils/printWhenDebug.dart';

class ApiService {
  var dio = Dio();

  final LocalStorage _localStorage = LocalStorage();
  Completer<String>? stopRequests;
  final String baseUrl;

  ApiService(this.baseUrl) {
    _refreshAccessToken();
    loadMainAPI();
  }

  loadMainAPI() {
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = 30000
      ..options.receiveTimeout = 60000
      ..options.headers = {'Content-Type': 'application/json; charset=utf-8'}
      ..interceptors.add(LogInterceptor(
        request: kDebugMode,
        responseBody: kDebugMode,
        requestBody: kDebugMode,
        requestHeader: kDebugMode,
      ))
      ..interceptors.add(
        InterceptorsWrapper(onResponse: (response, handler) {
          handler.next(response);
        }, onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          var token = await _localStorage.token();
          if (token.isNotEmpty) {
            options.headers.putIfAbsent('Authorization', () => "Bearer $token");
          } else {
            // Auth Token is null
          }
          return handler.next(options);
        }, onError: (DioError e, ErrorInterceptorHandler handler) async {
          if (e.response?.statusCode == 401) {
            if (!e.requestOptions.queryParameters.containsKey("retry")) {
              if (stopRequests == null) {
                stopRequests = Completer<String>();
                try {
                  var idToken = await _refreshAccessToken();
                  stopRequests?.complete(idToken);
                } catch (error) {
                  stopRequests = null;
                  return handler.next(e);
                }
              }
              var idToken = await stopRequests?.future;
              idToken ??= await _localStorage.token();
              try {
                var response = await _retry(e.requestOptions, idToken);
                stopRequests = null;
                return handler.resolve(response);
              } on DioError catch (error) {
                stopRequests = null;
                return handler.next(error);
              } catch (error) {
                stopRequests = null;
                return handler.next(e);
              }
            } else {
              if (!(stopRequests?.isCompleted ?? true)) {
                stopRequests?.complete("");
              }
              stopRequests = null;
              _localStorage.clearStorage();
            }
          } else if (e.type == DioErrorType.connectTimeout) {
            var idToken = await _localStorage.token();
            try {
              var response = await _retry(e.requestOptions, idToken);
              return handler.resolve(response);
            } on DioError catch (ex) {
              return handler.next(ex);
            } catch (exx) {
              return handler.next(e);
            }
          } else {
            // crash loggers
            printWhenDebug('no id token');
          }
          return handler.next(e);
        }),
      );
  }

  Future<Response<dynamic>> _retry(
      RequestOptions requestOptions, String idToken) async {
    var data = requestOptions.data;
    if (data is FormData) {
      var mapExtra = requestOptions.extra;
      Map<String, dynamic> files = {};
      for (var extra in mapExtra.entries) {
        var pathObj = extra.value;
        if (pathObj is String) {
          if (pathObj.isNotEmpty) {
            files[extra.key] = await MultipartFile.fromFile(pathObj,
                filename: pathObj.split("/").last);
          }
        } else if (pathObj is List) {
          files[extra.key] = [];
          for (var pathItem in pathObj) {
            (files[extra.key] as List).add(await MultipartFile.fromFile(
                pathItem,
                filename: pathItem.split("/").last));
          }
        }
      }
      var form = FormData.fromMap({}
        ..addAll(Map.fromEntries(data.fields.toSet()))
        ..addAll(files));
      data = form;
    }
    return dio.request<dynamic>(requestOptions.path,
        data: data,
        queryParameters: requestOptions.queryParameters
          ..putIfAbsent("retry", () => true),
        options: Options(
            method: requestOptions.method,
            headers: {"Authorization": "Bearer $idToken"}));
  }

  Future<String> _refreshAccessToken() async {
    // refetch token here
    // var tokenRes = await firebaseService.auth.currentUser?.getIdTokenResult(true);
    // if (tokenRes?.token?.isEmpty ?? true) {
    //   printWhenDebug('no id token');
    //   return "";
    // }
    //
    // await _localStorage.saveToken(tokenRes!.token!);
    // _localStorage.saveTokenExp(tokenRes.expirationTime!.millisecond);
    // printWhenDebug("Token refreshed successfully.");
    return "tokenRes.token!";
    // return tokenRes.token!;
  }

}
