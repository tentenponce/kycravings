import 'package:flutter_test/flutter_test.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/repositories/cravings_history_repository.dart';
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
])
void main() {
  group(HomeCubit, () {
    late MockLogger mockLogger;
    late MockPredictUseCase mockPredictUseCase;
    late MockCravingsHistoryRepository mockCravingsHistoryRepository;
    setUp(() {
      mockLogger = MockLogger();
      mockPredictUseCase = MockPredictUseCase();
      mockCravingsHistoryRepository = MockCravingsHistoryRepository();
    });

    HomeCubit createUnitToTest() {
      return HomeCubit(
        mockLogger,
        mockPredictUseCase,
        mockCravingsHistoryRepository,
      );
    }

    test('predict should emit predicted craving successfully', () async {
      final mockPredictedCraving = CravingModel.test;
      when(mockPredictUseCase.predict()).thenAnswer((_) async => mockPredictedCraving);

      final unit = createUnitToTest();
      await unit.predict();

      expect(unit.state.predictedCraving, mockPredictedCraving);
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
