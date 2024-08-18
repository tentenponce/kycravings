import 'package:injectable/injectable.dart';
import 'package:kycravings/core/infrastructure/platform/firebase_app_core.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/repositories/ignored_cravings_repository.dart';
import 'package:kycravings/domain/use_cases/get_initial_cravings_use_case.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';
import 'package:kycravings/presentation/shared/utils/navigation_utils.dart';

@injectable
class SplashCubit extends BaseCubit<void> {
  final Logger _logger;
  final GetInitialCravingsUseCase _getInitialCravingsUseCase;
  final IgnoredCravingsRepository _ignoredCravingsRepository;
  final FirebaseAppCore _firebaseAppCore;
  final NavigationUtils _navigationUtils;

  SplashCubit(
    this._logger,
    this._getInitialCravingsUseCase,
    this._ignoredCravingsRepository,
    this._firebaseAppCore,
    this._navigationUtils,
  ) : super(null) {
    _logger.logFor(this);
  }

  @override
  Future<void> init() async {
    // init firebase
    await _firebaseAppCore.initializeApp();

    // load initial data
    await _getInitialCravingsUseCase.load();

    // cleanup ignored cravings
    final deletedCount = await _ignoredCravingsRepository.deletePreviousDays();
    _logger.log(LogLevel.info, 'deleted $deletedCount ignored cravings');

    // navigate to home screen
    await _navigationUtils.pushReplacement<void>(ViewRoute.home);
  }
}
