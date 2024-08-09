import 'package:injectable/injectable.dart';

abstract interface class EnvironmentVariables {
  String get firebaseApiKey;

  String get firebaseAppId;

  String get firebaseMessagingSenderId;

  String get firebaseProjectId;

  String get firebaseStorageBucket;
}

@LazySingleton(as: EnvironmentVariables)
class EnvironmentVariablesImpl implements EnvironmentVariables {
  @override
  String get firebaseApiKey => const String.fromEnvironment('firebaseApiKey');

  @override
  String get firebaseAppId => const String.fromEnvironment('firebaseAppId');

  @override
  String get firebaseMessagingSenderId => const String.fromEnvironment('firebaseMessagingSenderId');

  @override
  String get firebaseProjectId => const String.fromEnvironment('firebaseProjectId');

  @override
  String get firebaseStorageBucket => const String.fromEnvironment('firebaseStorageBucket');
}
