import 'package:injectable/injectable.dart';
import 'package:kycravings/core/infrastructure/platform/firebase_app_core.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/repositories/ignored_cravings_repository.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';
import 'package:kycravings/presentation/shared/utils/navigation_utils.dart';

@injectable
class SplashCubit extends BaseCubit<void> {
  final Logger _logger;
  final IgnoredCravingsRepository _ignoredCravingsRepository;
  final FirebaseAppCore _firebaseAppCore;
  final NavigationUtils _navigationUtils;

  SplashCubit(
    this._logger,
    this._ignoredCravingsRepository,
    this._firebaseAppCore,
    this._navigationUtils,
  ) : super(null);

  @override
  Future<void> init() async {
    // init firebase
    await _firebaseAppCore.initializeApp();

    // cleanup ignored cravings
    final deletedCount = await _ignoredCravingsRepository.deletePreviousDays();
    _logger.log(LogLevel.info, 'deleted $deletedCount ignored cravings');

    // navigate to home screen
    await _navigationUtils.push<void>(ViewRoute.home);
  }
}
