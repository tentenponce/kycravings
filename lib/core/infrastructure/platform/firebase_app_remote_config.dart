import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';

abstract interface class FirebaseAppRemoteConfig {
  Future<void> init();
  T getData<T>(String key);
}

@LazySingleton(as: FirebaseAppRemoteConfig)
class FirebaseAppRemoteConfigImpl implements FirebaseAppRemoteConfig {
  late FirebaseRemoteConfig _firebaseRemoteConfig;

  @override
  Future<void> init() async {
    _firebaseRemoteConfig = FirebaseRemoteConfig.instance;
    await _firebaseRemoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(days: 1),
      ),
    );

    await _firebaseRemoteConfig.fetchAndActivate();
  }

  @override
  T getData<T>(String key) {
    if (T == String) {
      return _firebaseRemoteConfig.getString(key) as T;
    } else if (T == bool) {
      return _firebaseRemoteConfig.getBool(key) as T;
    } else if (T == int) {
      return _firebaseRemoteConfig.getInt(key) as T;
    } else if (T == double) {
      return _firebaseRemoteConfig.getDouble(key) as T;
    } else {
      throw Exception('Unsupported type');
    }
  }
}
