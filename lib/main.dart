import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/bootstrap.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[RunLab] ${details.exceptionAsString()}\n${details.stack}');
    }
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[RunLab] ErrorWidget: ${details.exceptionAsString()}');
    }
    return ErrorWidget(details.exception);
  };

  bootstrap();
}
