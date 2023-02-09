import 'package:flutter/foundation.dart';

void printWhenDebug(Object? error) {
  if (kDebugMode) {
    print(error);
  }
}