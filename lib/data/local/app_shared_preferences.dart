import 'package:injectable/injectable.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/presentation/shared/utils/string_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AppSharedPreferences {
  Future<bool> clear(String key);

  Future<bool> clearAll();

  Future<T?> getValue<T>(String key);

  Future<bool> setValue(String key, Object value);
}

@LazySingleton(as: AppSharedPreferences)
class AppSharedPreferencesImpl implements AppSharedPreferences {
  final Logger _logger;
  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.reload();

    return _prefs!;
  }

  AppSharedPreferencesImpl(
    this._logger,
  ) {
    _logger.logFor(this);
  }

  @override
  Future<bool> clear(String key) async {
    assert(!StringUtils.isNullOrEmpty(key), 'Key cannot be null or empty');

    return (await prefs).remove(key);
  }

  @override
  Future<bool> clearAll() async => (await prefs).clear();

  @override
  Future<T?> getValue<T>(String key) async {
    assert(!StringUtils.isNullOrEmpty(key), 'Key cannot be null or empty');

    final value = (await prefs).get(key);

    return value as T?;
  }

  @override
  Future<bool> setValue(String key, Object value) async {
    assert(!StringUtils.isNullOrEmpty(key), 'Key cannot be null or empty');

    if (value is String) {
      return (await prefs).setString(key, value);
    } else if (value is int) {
      return (await prefs).setInt(key, value);
    } else if (value is double) {
      return (await prefs).setDouble(key, value);
    } else if (value is bool) {
      return (await prefs).setBool(key, value);
    } else {
      _logger.log(
        LogLevel.warning,
        '${value.runtimeType} not supported, implicitly saving as string',
      );

      return (await prefs).setString(key, value.toString());
    }
  }
}
