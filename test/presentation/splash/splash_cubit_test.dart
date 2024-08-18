import 'package:flutter_test/flutter_test.dart';
import 'package:kycravings/core/infrastructure/platform/firebase_app_core.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/repositories/ignored_cravings_repository.dart';
import 'package:kycravings/domain/use_cases/get_initial_cravings_use_case.dart';
import 'package:kycravings/presentation/shared/utils/navigation_utils.dart';
import 'package:kycravings/presentation/update_cravings/cubits/update_cravings_cubit.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<GetInitialCravingsUseCase>(),
  MockSpec<IgnoredCravingsRepository>(),
  MockSpec<FirebaseAppCore>(),
  MockSpec<NavigationUtils>(),
])
void main() {
  group(UpdateCravingsCubit, () {
    setUp(() async {});
  });
}
