import 'package:flutter_test/flutter_test.dart';
import 'package:kycravings/core/infrastructure/platform/firebase_app_analytics.dart';
import 'package:kycravings/data/db/repositories/cravings_repository.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/presentation/your_cravings/cubits/your_cravings_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'your_cravings_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CravingsRepository>(),
  MockSpec<FirebaseAppAnalytics>(),
])
void main() {
  group(YourCravingsCubit, () {
    late MockCravingsRepository mockCravingsRepository;
    late MockFirebaseAppAnalytics mockFirebaseAppAnalytics;

    setUp(() {
      mockCravingsRepository = MockCravingsRepository();
      mockFirebaseAppAnalytics = MockFirebaseAppAnalytics();
    });

    YourCravingsCubit createUnitToTest() {
      return YourCravingsCubit(
        mockCravingsRepository,
        mockFirebaseAppAnalytics,
      )..onInitialLoad = () {};
    }

    test('getCravings should emit cravings successfully', () async {
      final mockCravings = [
        CravingModel.test,
        CravingModel.test,
      ];
      when(mockCravingsRepository.selectWithCategories(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => mockCravings);

      final unit = createUnitToTest();
      await unit.getCravings();

      verify(mockCravingsRepository.selectWithCategories(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).called(2);
      expect(unit.state.cravings, mockCravings);
    });

    test('onScrollBottom should append new list if has more data', () async {
      final mockCravings = [
        CravingModel.test,
        CravingModel.test,
      ];

      when(mockCravingsRepository.selectWithCategories(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => mockCravings);

      final unit = createUnitToTest();

      await unit.init();

      final newCravings = [
        CravingModel.test.copyWith(id: 3),
        CravingModel.test.copyWith(id: 4),
      ];

      when(mockCravingsRepository.selectWithCategories(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => newCravings);

      await unit.onScrollBottom();

      verify(mockCravingsRepository.selectWithCategories(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).called(3);

      expect(unit.state.cravings, [...mockCravings, ...newCravings]);
    });

    test('onScrollBottom should not call craving history if already reached bottom', () async {
      final mockCravingHistory = [
        CravingModel.test,
        CravingModel.test,
      ];

      when(mockCravingsRepository.selectWithCategories(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => mockCravingHistory);

      final unit = createUnitToTest();

      await unit.init();

      when(mockCravingsRepository.selectWithCategories(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => []);

      await unit.onScrollBottom();
      await unit.onScrollBottom();

      verify(mockCravingsRepository.selectWithCategories(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).called(3);
    });

    test('onCravingDelete should delete craving and remove from state', () async {
      final mockCravings = [
        CravingModel.test.copyWith(id: 1),
        CravingModel.test.copyWith(id: 2),
      ];
      const cravingIdToDelete = 2;
      when(mockCravingsRepository.selectWithCategories(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => mockCravings);

      final unit = createUnitToTest();
      await unit.getCravings();

      await unit.onCravingDelete(cravingIdToDelete);

      verify(mockCravingsRepository.remove(cravingIdToDelete)).called(1);
      expect(unit.state.cravings, mockCravings..remove(mockCravings[1]));
    });
  });
}
