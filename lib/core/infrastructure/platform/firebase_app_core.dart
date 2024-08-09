import 'package:firebase_core/firebase_core.dart';
import 'package:injectable/injectable.dart';
import 'package:kycravings/core/infrastructure/platform/environment_variables.dart';
import 'package:kycravings/core/infrastructure/platform/firebase_app_analytics.dart';
import 'package:kycravings/core/logging/logger.dart';

abstract interface class FirebaseAppCore {
  Future<void> initializeApp();
}

@LazySingleton(as: FirebaseAppCore)
class FirebaseAppCoreImpl implements FirebaseAppCore {
  final Logger _logger;
  final EnvironmentVariables _environmentVariables;
  final FirebaseAppAnalytics _firebaseAppAnalytics;

  FirebaseAppCoreImpl(
    this._logger,
    this._environmentVariables,
    this._firebaseAppAnalytics,
  ) {
    _logger.logFor(this);
  }

  @override
  Future<void> initializeApp() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: _environmentVariables.firebaseApiKey,
          appId: _environmentVariables.firebaseAppId,
          messagingSenderId: _environmentVariables.firebaseMessagingSenderId,
          projectId: _environmentVariables.firebaseProjectId,
          storageBucket: _environmentVariables.firebaseStorageBucket,
        ),
      );

      _logger.log(LogLevel.debug, 'Firebase app initialized');
    }

    await _firebaseAppAnalytics.init();
  }
}
