import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kycravings/di/dependency_injection.dart';
import 'package:kycravings/presentation/app/app.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      catchUnhandledExceptions(details.exception, details.stack);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      catchUnhandledExceptions(error, stack);
      return true;
    };

    configureDependencies();
    runApp(const App());
  }, catchUnhandledExceptions);
}

void catchUnhandledExceptions(Object error, StackTrace? stack) {
  unawaited(FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
  debugPrintStack(stackTrace: stack, label: error.toString());
}
