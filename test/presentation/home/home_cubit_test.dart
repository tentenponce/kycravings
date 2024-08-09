import 'package:flutter_test/flutter_test.dart';
import 'package:kycravings/core/infrastructure/platform/firebase_app_analytics.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/repositories/cravings_history_repository.dart';
import 'package:kycravings/data/db/repositories/ignored_cravings_repository.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/domain/use_cases/predict_use_case.dart';
import 'package:kycravings/presentation/home/cubits/home_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<PredictUseCase>(),
  MockSpec<CravingsHistoryRepository>(),
  MockSpec<IgnoredCravingsRepository>(),
  MockSpec<FirebaseAppAnalytics>(),
])
void main() {
  group(HomeCubit, () {
    late MockLogger mockLogger;
    late MockPredictUseCase mockPredictUseCase;
    late MockCravingsHistoryRepository mockCravingsHistoryRepository;
    late MockIgnoredCravingsRepository mockIgnoredCravingsRepository;
    late MockFirebaseAppAnalytics mockFirebaseAppAnalytics;
    setUp(() {
      mockLogger = MockLogger();
      mockPredictUseCase = MockPredictUseCase();
      mockCravingsHistoryRepository = MockCravingsHistoryRepository();
      mockIgnoredCravingsRepository = MockIgnoredCravingsRepository();
      mockFirebaseAppAnalytics = MockFirebaseAppAnalytics();
    });

    HomeCubit createUnitToTest() {
      return HomeCubit(
        mockLogger,
        mockPredictUseCase,
        mockCravingsHistoryRepository,
        mockIgnoredCravingsRepository,
        mockFirebaseAppAnalytics,
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
  });
}
