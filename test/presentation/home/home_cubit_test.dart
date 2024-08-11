import 'package:flutter_test/flutter_test.dart';
import 'package:kycravings/core/infrastructure/constants/shared_prefs_keys.dart';
import 'package:kycravings/core/infrastructure/platform/firebase_app_analytics.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/repositories/cravings_history_repository.dart';
import 'package:kycravings/data/db/repositories/ignored_cravings_repository.dart';
import 'package:kycravings/data/local/app_shared_preferences.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/domain/use_cases/predict_use_case.dart';
import 'package:kycravings/presentation/home/cubits/home_cubit.dart';
import 'package:kycravings/presentation/shared/utils/delay_utils.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<PredictUseCase>(),
  MockSpec<CravingsHistoryRepository>(),
  MockSpec<IgnoredCravingsRepository>(),
  MockSpec<AppSharedPreferences>(),
  MockSpec<FirebaseAppAnalytics>(),
  MockSpec<DelayUtils>(),
])
void main() {
  group(HomeCubit, () {
    late MockLogger mockLogger;
    late MockPredictUseCase mockPredictUseCase;
    late MockCravingsHistoryRepository mockCravingsHistoryRepository;
    late MockIgnoredCravingsRepository mockIgnoredCravingsRepository;
    late MockAppSharedPreferences mockAppSharedPreferences;
    late MockFirebaseAppAnalytics mockFirebaseAppAnalytics;
    late MockDelayUtils mockDelayUtils;
    setUp(() async {
      mockLogger = MockLogger();
      mockPredictUseCase = MockPredictUseCase();
      mockCravingsHistoryRepository = MockCravingsHistoryRepository();
      mockIgnoredCravingsRepository = MockIgnoredCravingsRepository();
      mockAppSharedPreferences = MockAppSharedPreferences();
      mockFirebaseAppAnalytics = MockFirebaseAppAnalytics();
      mockDelayUtils = MockDelayUtils();

      when(mockDelayUtils.delay(any)).thenAnswer((_) async {});
    });

    HomeCubit createUnitToTest() {
      return HomeCubit(
        mockLogger,
        mockPredictUseCase,
        mockCravingsHistoryRepository,
        mockIgnoredCravingsRepository,
        mockAppSharedPreferences,
        mockFirebaseAppAnalytics,
        mockDelayUtils,
      );
    }

    test('predict should emit predicted craving successfully', () async {
      final mockPredictedCraving = CravingModel.test;
      when(mockPredictUseCase.predict()).thenAnswer((_) async => mockPredictedCraving);

      final unit = createUnitToTest();
      await unit.predict();

      expect(unit.state.predictedCraving, mockPredictedCraving);
    });

    test('predict should ignore craving if predicted again with predicted craving already', () async {
      final mockPredictedCraving = CravingModel.test;
      when(mockPredictUseCase.predict()).thenAnswer((_) async => mockPredictedCraving);

      final unit = createUnitToTest();
      await unit.predict(); // predict initially
      await unit.predict(); // predict again, ignoring the previous predict

      verify(mockIgnoredCravingsRepository.insert(mockPredictedCraving)).called(1);
    });

    test('chooseCraving should insert to history successfully', () async {
      final mockPredictedCraving = CravingModel.test;
      when(mockPredictUseCase.predict()).thenAnswer((_) async => mockPredictedCraving);

      final unit = createUnitToTest();
      await unit.predict();
      await unit.chooseCraving();

      verify(mockCravingsHistoryRepository.insert(mockPredictedCraving)).called(1);
    });

    test('chooseCraving should clear predicted craving successfully', () async {
      final mockPredictedCraving = CravingModel.test;
      when(mockPredictUseCase.predict()).thenAnswer((_) async => mockPredictedCraving);

      final unit = createUnitToTest();
      await unit.predict();
      await unit.chooseCraving();

      expect(unit.state.predictedCraving, null);
    });

    test('doNotShowCravingSatisfiedDialogAgain should set to shared preferences', () async {
      when(mockAppSharedPreferences.getValue<bool>(SharedPrefsKeys.doNotShowCravingSatisfiedDialogAgain))
          .thenAnswer((_) async => false);

      final unit = createUnitToTest();
      await unit.init();
      await unit.doNotShowCravingSatisfiedDialogAgain(isDontShowAgain: true);

      await expectLater(unit.isDoNotShowCravingSatisfiedDialogAgain, true);
      verify(mockAppSharedPreferences.setValue(SharedPrefsKeys.doNotShowCravingSatisfiedDialogAgain, true)).called(1);
    });
  });
}
