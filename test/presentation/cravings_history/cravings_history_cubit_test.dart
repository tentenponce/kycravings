import 'package:flutter_test/flutter_test.dart';
import 'package:kycravings/data/db/repositories/cravings_history_repository.dart';
import 'package:kycravings/domain/models/craving_history_model.dart';
import 'package:kycravings/presentation/cravings_history/cubits/cravings_history_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cravings_history_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CravingsHistoryRepository>(),
])
void main() {
  group(CravingsHistoryCubit, () {
    late MockCravingsHistoryRepository mockCravingsHistoryRepository;

    setUp(() {
      mockCravingsHistoryRepository = MockCravingsHistoryRepository();
    });

    CravingsHistoryCubit createUnitToTest() {
      return CravingsHistoryCubit(
        mockCravingsHistoryRepository,
      )..onInitialLoad = () {};
    }

    test('init should get craving history successfully', () async {
      final mockCravingHistory = [
        CravingHistoryModel.test,
        CravingHistoryModel.test,
      ];

      when(mockCravingsHistoryRepository.selectAll(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => mockCravingHistory);

      final unit = createUnitToTest();

      await unit.init();

      verify(mockCravingsHistoryRepository.selectAll(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).called(2);
      expect(unit.state.cravingsHistory, mockCravingHistory);
    });

    test('onScrollBottom should append new list if has more data', () async {
      final mockCravingHistory = [
        CravingHistoryModel.test,
        CravingHistoryModel.test,
      ];

      when(mockCravingsHistoryRepository.selectAll(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => mockCravingHistory);

      final unit = createUnitToTest();

      await unit.init();

      final newCravingHistory = [
        CravingHistoryModel.test.copyWith(id: 3),
        CravingHistoryModel.test.copyWith(id: 4),
      ];

      when(mockCravingsHistoryRepository.selectAll(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => newCravingHistory);

      await unit.onScrollBottom();

      verify(mockCravingsHistoryRepository.selectAll(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).called(3);

      expect(unit.state.cravingsHistory, [...mockCravingHistory, ...newCravingHistory]);
    });

    test('onScrollBottom should not call craving history if already reached bottom', () async {
      final mockCravingHistory = [
        CravingHistoryModel.test,
        CravingHistoryModel.test,
      ];

      when(mockCravingsHistoryRepository.selectAll(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => mockCravingHistory);

      final unit = createUnitToTest();

      await unit.init();

      when(mockCravingsHistoryRepository.selectAll(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => []);

      await unit.onScrollBottom();
      await unit.onScrollBottom();

      verify(mockCravingsHistoryRepository.selectAll(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).called(3);
    });

    test('onCravingDelete should delete craving history successfully', () async {
      final mockCravingHistory = [
        CravingHistoryModel.test.copyWith(id: 1),
        CravingHistoryModel.test.copyWith(id: 2),
      ];

      when(mockCravingsHistoryRepository.selectAll(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => mockCravingHistory);

      final unit = createUnitToTest();

      await unit.init();

      final cravingHistoryId = mockCravingHistory.first.id;

      unit.onCravingDelete(cravingHistoryId);

      verify(mockCravingsHistoryRepository.remove(cravingHistoryId)).called(1);
      expect(unit.state.cravingsHistory, [mockCravingHistory[1]]);
    });
  });
}
