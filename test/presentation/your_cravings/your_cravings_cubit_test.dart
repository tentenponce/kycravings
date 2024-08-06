import 'package:flutter_test/flutter_test.dart';
import 'package:kycravings/data/db/repositories/cravings_repository.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/presentation/your_cravings/cubits/your_cravings_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'your_cravings_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CravingsRepository>(),
])
void main() {
  group(YourCravingsCubit, () {
    late MockCravingsRepository mockCravingsRepository;

    setUp(() {
      mockCravingsRepository = MockCravingsRepository();
    });

    YourCravingsCubit createUnitToTest() {
      return YourCravingsCubit(
        mockCravingsRepository,
      );
    }

    test('getCravings should emit cravings successfully', () async {
      final mockCravings = [
        CravingModel.test,
        CravingModel.test,
      ];
      when(mockCravingsRepository.selectWithCategories()).thenAnswer((_) async => mockCravings);

      final unit = createUnitToTest();
      await unit.getCravings();

      verify(mockCravingsRepository.selectWithCategories()).called(2);
      expect(unit.state.cravings, mockCravings);
    });

    test('onCravingDelete should delete craving and remove from state', () async {
      final mockCravings = [
        CravingModel.test.copyWith(id: 1),
        CravingModel.test.copyWith(id: 2),
      ];
      const cravingIdToDelete = 2;
      when(mockCravingsRepository.selectWithCategories()).thenAnswer((_) async => mockCravings);

      final unit = createUnitToTest();
      await unit.getCravings();

      unit.onCravingDelete(cravingIdToDelete);

      verify(mockCravingsRepository.remove(cravingIdToDelete)).called(1);
      expect(unit.state.cravings, mockCravings..remove(mockCravings[1]));
    });
  });
}
