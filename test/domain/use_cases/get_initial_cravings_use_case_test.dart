import 'package:flutter_test/flutter_test.dart';
import 'package:kycravings/core/infrastructure/constants/remote_config_keys.dart';
import 'package:kycravings/core/infrastructure/constants/shared_prefs_keys.dart';
import 'package:kycravings/core/infrastructure/platform/firebase_app_remote_config.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/repositories/categories_repository.dart';
import 'package:kycravings/data/db/repositories/cravings_repository.dart';
import 'package:kycravings/data/local/app_shared_preferences.dart';
import 'package:kycravings/domain/use_cases/get_initial_cravings_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_initial_cravings_use_case_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<CravingsRepository>(),
  MockSpec<CategoriesRepository>(),
  MockSpec<AppSharedPreferences>(),
  MockSpec<FirebaseAppRemoteConfig>(),
])
void main() {
  group(GetInitialCravingsUseCase, () {
    late MockLogger mockLogger;
    late MockCravingsRepository mockCravingsRepository;
    late MockCategoriesRepository mockCategoriesRepository;
    late MockAppSharedPreferences mockAppSharedPreferences;
    late MockFirebaseAppRemoteConfig mockFirebaseAppRemoteConfig;
    setUp(() {
      mockLogger = MockLogger();
      mockCravingsRepository = MockCravingsRepository();
      mockCategoriesRepository = MockCategoriesRepository();
      mockAppSharedPreferences = MockAppSharedPreferences();
      mockFirebaseAppRemoteConfig = MockFirebaseAppRemoteConfig();
    });

    GetInitialCravingsUseCase createUnitToTest() {
      return GetInitialCravingsUseCaseImpl(
        mockLogger,
        mockCravingsRepository,
        mockCategoriesRepository,
        mockAppSharedPreferences,
        mockFirebaseAppRemoteConfig,
      );
    }

    test('should return if data already loaded', () async {
      when(mockAppSharedPreferences.getValue<bool>(SharedPrefsKeys.isInitialDataLoaded)).thenAnswer((_) async => true);

      final unit = createUnitToTest();
      await unit.load();

      verify(mockLogger.log(LogLevel.debug, 'Initial data has already been loaded')).called(1);
      verifyZeroInteractions(mockFirebaseAppRemoteConfig);
    });

    test('should load data from remote config if data is not yet loaded', () async {
      when(mockAppSharedPreferences.getValue<bool>(SharedPrefsKeys.isInitialDataLoaded)).thenAnswer((_) async => false);
      when(mockFirebaseAppRemoteConfig.getData<String>(RemoteConfigKeys.preLoadCravings)).thenAnswer(
        (_) => '[{"id":0,"name":"Sinigang","categories":[1,2]}]',
      );
      when(mockFirebaseAppRemoteConfig.getData<String>(RemoteConfigKeys.preLoadCategories)).thenAnswer(
        (_) => '[{"id":0,"name":"Sabaw"},{"id":1,"name":"Pork"},{"id":2,"name": "Salty"}]',
      );

      final unit = createUnitToTest();
      await unit.load();

      verify(mockCategoriesRepository.insertAll(any)).called(1);
      verify(mockCravingsRepository.insertAll(any)).called(1);
      verify(mockAppSharedPreferences.setValue(SharedPrefsKeys.isInitialDataLoaded, true)).called(1);
    });
  });
}
