import 'package:flutter_test/flutter_test.dart';
import 'package:kycravings/data/db/repositories/cravings_history_repository.dart';
import 'package:kycravings/domain/models/craving_history_model.dart';
import 'package:kycravings/presentation/cravings_history/cubits/cravings_history_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cravings_history_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CravingsHistoryRepository>()])
void main() {
  group(CravingsHistoryCubit, () {
    late MockCravingsHistoryRepository mockCravingsHistoryRepository;

    setUp(() {
      mockCravingsHistoryRepository = MockCravingsHistoryRepository();
    });

    CravingsHistoryCubit createUnitToTest() {
      return CravingsHistoryCubit(
        mockCravingsHistoryRepository,
      );
    }

    test('init should get craving history successfully', () async {
      final mockCravingHistory = [
        CravingHistoryModel.test,
        CravingHistoryModel.test,
      ];

      when(mockCravingsHistoryRepository.selectAll()).thenAnswer((_) async => mockCravingHistory);

      final unit = createUnitToTest();

      await unit.init();

      verify(mockCravingsHistoryRepository.selectAll()).called(2);
      expect(unit.state.cravingsHistory, mockCravingHistory);
    });

    test('onCravingDelete should delete craving history successfully', () async {
      final mockCravingHistory = [
        CravingHistoryModel.test.copyWith(id: 1),
        CravingHistoryModel.test.copyWith(id: 2),
      ];

      when(mockCravingsHistoryRepository.selectAll()).thenAnswer((_) async => mockCravingHistory);

      final unit = createUnitToTest();

      await unit.init();

      final cravingHistoryId = mockCravingHistory.first.id;

      unit.onCravingDelete(cravingHistoryId);

      verify(mockCravingsHistoryRepository.remove(cravingHistoryId)).called(1);
      expect(unit.state.cravingsHistory, [mockCravingHistory[1]]);
    });
  });
}
