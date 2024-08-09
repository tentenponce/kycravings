import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';
import 'package:kycravings/core/logging/logger.dart';

abstract interface class FirebaseAppAnalytics {
  Future<void> init();
  Future<void> logEvent({
    required String name,
    Map<String, String>? parameters,
  });
}

@LazySingleton(as: FirebaseAppAnalytics)
class FirebaseAppAnalyticsImpl implements FirebaseAppAnalytics {
  final Logger _logger;
  late FirebaseAnalytics _firebaseAnalytics;

  FirebaseAppAnalyticsImpl(
    this._logger,
  ) {
    _logger.logFor(this);
  }

  @override
  Future<void> init() async {
    _firebaseAnalytics = FirebaseAnalytics.instance;
  }

  @override
  Future<void> logEvent({required String name, Map<String, String>? parameters}) {
    return _firebaseAnalytics.logEvent(name: name, parameters: parameters);
  }
}
