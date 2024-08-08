import 'package:flutter_test/flutter_test.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/repositories/cravings_history_repository.dart';
import 'package:kycravings/data/db/repositories/cravings_repository.dart';
import 'package:kycravings/data/db/repositories/ignored_cravings_repository.dart';
import 'package:kycravings/domain/core/utils/date_time_utils.dart';
import 'package:kycravings/domain/core/utils/random_utils.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/domain/models/craving_preference_model.dart';
import 'package:kycravings/domain/use_cases/predict_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'predict_use_case_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<CravingsRepository>(),
  MockSpec<CravingsHistoryRepository>(),
  MockSpec<IgnoredCravingsRepository>(),
  MockSpec<DateTimeUtils>(),
  MockSpec<RandomUtils>(),
])
void main() {
  group(PredictUseCase, () {
    late MockLogger mockLogger;
    late MockCravingsRepository mockCravingsRepository;
    late MockCravingsHistoryRepository mockCravingsHistoryRepository;
    late MockIgnoredCravingsRepository mockIgnoredCravingsRepository;
    late MockDateTimeUtils mockDateTimeUtils;
    late MockRandomUtils mockRandomUtils;
    setUp(() {
      mockLogger = MockLogger();
      mockCravingsRepository = MockCravingsRepository();
      mockCravingsHistoryRepository = MockCravingsHistoryRepository();
      mockIgnoredCravingsRepository = MockIgnoredCravingsRepository();
      mockDateTimeUtils = MockDateTimeUtils();
      mockRandomUtils = MockRandomUtils();

      when(mockDateTimeUtils.now()).thenReturn(DateTime.now());
    });

    PredictUseCase createUnitToTest() {
      return PredictUseCaseImpl(
        mockLogger,
        mockCravingsRepository,
        mockCravingsHistoryRepository,
        mockIgnoredCravingsRepository,
        mockDateTimeUtils,
        mockRandomUtils,
      );
    }

    test('should randomize craving if same score', () async {
      final mockCravings = [
        CravingModel.test.copyWith(id: 1),
        CravingModel.test.copyWith(id: 2),
        CravingModel.test.copyWith(id: 3),
      ];

      final mockLastChosen = DateTime.now();
      final mockCravingsHistory = [
        CravingPreferenceModel(cravingModel: mockCravings[0], preferenceCount: 0, lastChosen: mockLastChosen),
        CravingPreferenceModel(cravingModel: mockCravings[1], preferenceCount: 0, lastChosen: mockLastChosen),
        CravingPreferenceModel(cravingModel: mockCravings[2], preferenceCount: 0, lastChosen: mockLastChosen),
      ];
      when(mockCravingsRepository.selectWithCategories()).thenAnswer((_) async => mockCravings);
      when(mockCravingsHistoryRepository.cravingPreferences()).thenAnswer((_) async => mockCravingsHistory);
      when(mockIgnoredCravingsRepository.ignoredCravings()).thenAnswer((_) async => []);

      final unit = createUnitToTest();
      await unit.predict();

      verify(mockRandomUtils.randomizeInt(0, 2)).called(1);
    });

    test('should return the least preferred craving', () async {
      final mockCravings = [
        CravingModel.test.copyWith(id: 1),
        CravingModel.test.copyWith(id: 2),
        CravingModel.test.copyWith(id: 3),
      ];

      final mockLastChosen = DateTime.now();
      final mockCravingsHistory = [
        CravingPreferenceModel(cravingModel: mockCravings[0], preferenceCount: 0, lastChosen: mockLastChosen),
        CravingPreferenceModel(cravingModel: mockCravings[1], preferenceCount: 1, lastChosen: mockLastChosen),
        CravingPreferenceModel(cravingModel: mockCravings[2], preferenceCount: 2, lastChosen: mockLastChosen),
      ];
      when(mockCravingsRepository.selectWithCategories()).thenAnswer((_) async => mockCravings);
      when(mockCravingsHistoryRepository.cravingPreferences()).thenAnswer((_) async => mockCravingsHistory);
      when(mockIgnoredCravingsRepository.ignoredCravings()).thenAnswer((_) async => []);

      final unit = createUnitToTest();
      final predictedCraving = await unit.predict();

      expect(predictedCraving, mockCravings[0]);
    });

    test('should return the least ignored craving', () async {
      final mockCravings = [
        CravingModel.test.copyWith(id: 1),
        CravingModel.test.copyWith(id: 2),
        CravingModel.test.copyWith(id: 3),
      ];

      final mockLastChosen = DateTime.now();
      final mockIgnoredCravings = [
        CravingPreferenceModel(cravingModel: mockCravings[0], preferenceCount: 0, lastChosen: mockLastChosen),
        CravingPreferenceModel(cravingModel: mockCravings[1], preferenceCount: 1, lastChosen: mockLastChosen),
        CravingPreferenceModel(cravingModel: mockCravings[2], preferenceCount: 2, lastChosen: mockLastChosen),
      ];
      when(mockCravingsRepository.selectWithCategories()).thenAnswer((_) async => mockCravings);
      when(mockCravingsHistoryRepository.cravingPreferences()).thenAnswer((_) async => []);
      when(mockIgnoredCravingsRepository.ignoredCravings()).thenAnswer((_) async => mockIgnoredCravings);

      final unit = createUnitToTest();
      final predictedCraving = await unit.predict();

      expect(predictedCraving, mockCravings[0]);
    });

    test('should return the oldest craving', () async {
      final mockCravings = [
        CravingModel.test.copyWith(id: 1),
        CravingModel.test.copyWith(id: 2),
        CravingModel.test.copyWith(id: 3),
      ];

      final mockLastChosen = DateTime.now();
      final mockPreferredCravings = [
        CravingPreferenceModel(
          cravingModel: mockCravings[0],
          preferenceCount: 1,
          lastChosen: mockLastChosen.add(const Duration(days: -1)),
        ),
        CravingPreferenceModel(
          cravingModel: mockCravings[1],
          preferenceCount: 1,
          lastChosen: mockLastChosen.add(const Duration(days: -2)),
        ),
        CravingPreferenceModel(
          cravingModel: mockCravings[2],
          preferenceCount: 1,
          lastChosen: mockLastChosen.add(const Duration(days: -3)),
        ),
      ];
      when(mockCravingsRepository.selectWithCategories()).thenAnswer((_) async => mockCravings);
      when(mockCravingsHistoryRepository.cravingPreferences()).thenAnswer((_) async => mockPreferredCravings);
      when(mockIgnoredCravingsRepository.ignoredCravings()).thenAnswer((_) async => []);

      final unit = createUnitToTest();
      final predictedCraving = await unit.predict();

      expect(predictedCraving, mockCravings[2]);
    });
  });
}
