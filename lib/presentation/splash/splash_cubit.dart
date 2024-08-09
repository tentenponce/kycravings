import 'package:injectable/injectable.dart';
import 'package:kycravings/core/infrastructure/platform/firebase_app_core.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';
import 'package:kycravings/presentation/shared/utils/navigation_utils.dart';

@injectable
class SplashCubit extends BaseCubit<void> {
  final FirebaseAppCore _firebaseAppCore;
  final NavigationUtils _navigationUtils;

  SplashCubit(
    this._firebaseAppCore,
    this._navigationUtils,
  ) : super(null);

  @override
  Future<void> init() async {
    await _firebaseAppCore.initializeApp();
    await _navigationUtils.push<void>(ViewRoute.home);
  }
}
