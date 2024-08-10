import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:kycravings/core/infrastructure/constants/remote_config_keys.dart';
import 'package:kycravings/core/infrastructure/constants/shared_prefs_keys.dart';
import 'package:kycravings/core/infrastructure/platform/firebase_app_remote_config.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/repositories/categories_repository.dart';
import 'package:kycravings/data/db/repositories/cravings_repository.dart';
import 'package:kycravings/data/local/app_shared_preferences.dart';
import 'package:kycravings/data/responses/category_response.dart';
import 'package:kycravings/data/responses/craving_response.dart';

abstract interface class GetInitialCravingsUseCase {
  Future<void> load();
}

@LazySingleton(as: GetInitialCravingsUseCase)
class GetInitialCravingsUseCaseImpl implements GetInitialCravingsUseCase {
  final Logger _logger;
  final CravingsRepository _cravingsRepository;
  final CategoriesRepository _categoriesRepository;
  final AppSharedPreferences _appSharedPreferences;
  final FirebaseAppRemoteConfig _firebaseAppRemoteConfig;

  GetInitialCravingsUseCaseImpl(
    this._logger,
    this._cravingsRepository,
    this._categoriesRepository,
    this._appSharedPreferences,
    this._firebaseAppRemoteConfig,
  );

  @override
  Future<void> load() async {
    final isInitialDataLoaded = await _appSharedPreferences.getValue<bool>(SharedPrefsKeys.isInitialDataLoaded);

    // If the initial data has already been loaded, return
    if (isInitialDataLoaded ?? false) {
      _logger.log(LogLevel.debug, 'Initial data has already been loaded');
      return;
    }

    final preLoadCravingsJson = _firebaseAppRemoteConfig.getData<String>(RemoteConfigKeys.preLoadCravings);
    final preLoadCategoriesJson = _firebaseAppRemoteConfig.getData<String>(RemoteConfigKeys.preLoadCategories);

    _logger.log(LogLevel.info, 'remote config cravings: $preLoadCravingsJson');
    _logger.log(LogLevel.info, 'remote config categories: $preLoadCategoriesJson');

    // Parse JSON string into a Map
    final parsedCravings = jsonDecode(preLoadCravingsJson) as Iterable<dynamic>;
    final parsedCategories = jsonDecode(preLoadCategoriesJson) as Iterable<dynamic>;

    // Insert cravings and categories into the database
    await _categoriesRepository.insertAll(
      parsedCategories.map((parsedCategory) => CategoryResponse.fromJson(parsedCategory as Map<String, dynamic>)),
    );
    await _cravingsRepository.insertAll(
      parsedCravings.map((parsedCraving) => CravingResponse.fromJson(parsedCraving as Map<String, dynamic>)),
    );

    _logger.log(LogLevel.info, 'successfully inserted initial data');

    // Set the flag to indicate that the initial data has been loaded
    await _appSharedPreferences.setValue(SharedPrefsKeys.isInitialDataLoaded, true);
  }
}
