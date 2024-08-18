import 'package:flutter_test/flutter_test.dart';
import 'package:kycravings/core/infrastructure/platform/firebase_app_core.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/repositories/ignored_cravings_repository.dart';
import 'package:kycravings/domain/use_cases/get_initial_cravings_use_case.dart';
import 'package:kycravings/presentation/update_cravings/cubits/update_cravings_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'splash_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<GetInitialCravingsUseCase>(),
  MockSpec<IgnoredCravingsRepository>(),
  MockSpec<FirebaseAppCore>(),
])
void main() {
  group(UpdateCravingsCubit, () {
    late MockLogger mockLogger;
    late MockGetInitialCravingsUseCase mockGetInitialCravingsUseCase;
    late MockIgnoredCravingsRepository mockIgnoredCravingsRepository;
    late MockFirebaseAppCore mockFirebaseAppCore;

    setUp(() async {
      mockLogger = MockLogger();
      mockGetInitialCravingsUseCase = MockGetInitialCravingsUseCase();
      mockIgnoredCravingsRepository = MockIgnoredCravingsRepository();
      mockFirebaseAppCore = MockFirebaseAppCore();

      when(mockFirebaseAppCore.initializeApp()).thenAnswer((_) async {});
      when(mockIgnoredCravingsRepository.deletePreviousDays()).thenAnswer((_) async => 0);
    });

    // SplashCubit createUnitToTest() {
    //   return SplashCubit(
    //     mockLogger,
    //     mockGetInitialCravingsUseCase,
    //     mockIgnoredCravingsRepository,
    //     mockFirebaseAppCore,
    //     mockNavigationUtils,
    //   );
    // }

    // test('init should clean up ignored cravings', () async {
    //   final unit = createUnitToTest();
    //   await unit.init();

    //   verify(mockIgnoredCravingsRepository.deletePreviousDays()).called(2);
    // });

    // test('init should initialize firebase', () async {
    //   final unit = createUnitToTest();
    //   await unit.init();

    //   verify(mockFirebaseAppCore.initializeApp()).called(2);
    // });

    // test('init should load initial cravings', () async {
    //   final unit = createUnitToTest();
    //   await unit.init();

    //   verify(mockGetInitialCravingsUseCase.load()).called(2);
    // });
  });
}
