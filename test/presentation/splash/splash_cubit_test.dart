import 'package:flutter_test/flutter_test.dart';
import 'package:kycravings/core/infrastructure/platform/firebase_app_core.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/repositories/ignored_cravings_repository.dart';
import 'package:kycravings/domain/use_cases/get_initial_cravings_use_case.dart';
import 'package:kycravings/presentation/shared/utils/navigation_utils.dart';
import 'package:kycravings/presentation/splash/splash_cubit.dart';
import 'package:mockito/annotations.dart';

import 'splash_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<GetInitialCravingsUseCase>(),
  MockSpec<IgnoredCravingsRepository>(),
  MockSpec<FirebaseAppCore>(),
  MockSpec<NavigationUtils>(),
])
void main() {
  group(SplashCubit, () {
    late MockLogger mockLogger;
    late MockGetInitialCravingsUseCase mockGetInitialCravingsUseCase;
    late MockIgnoredCravingsRepository mockIgnoredCravingsRepository;
    late MockFirebaseAppCore mockFirebaseAppCore;
    late MockNavigationUtils mockNavigationUtils;
    setUp(() {
      mockLogger = MockLogger();
      mockGetInitialCravingsUseCase = MockGetInitialCravingsUseCase();
      mockIgnoredCravingsRepository = MockIgnoredCravingsRepository();
      mockFirebaseAppCore = MockFirebaseAppCore();
      mockNavigationUtils = MockNavigationUtils();
    });

    SplashCubit createUnitToTest() {
      return SplashCubit(
        mockLogger,
        mockGetInitialCravingsUseCase,
        mockIgnoredCravingsRepository,
        mockFirebaseAppCore,
        mockNavigationUtils,
      );
    }
  });
}
