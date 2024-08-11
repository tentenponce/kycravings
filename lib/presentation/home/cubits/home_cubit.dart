import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:kycravings/core/infrastructure/constants/analytics_events.dart';
import 'package:kycravings/core/infrastructure/constants/shared_prefs_keys.dart';
import 'package:kycravings/core/infrastructure/platform/firebase_app_analytics.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/repositories/cravings_history_repository.dart';
import 'package:kycravings/data/db/repositories/ignored_cravings_repository.dart';
import 'package:kycravings/data/local/app_shared_preferences.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/domain/use_cases/predict_use_case.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';
import 'package:kycravings/presentation/home/states/home_state.dart';
import 'package:kycravings/presentation/shared/utils/delay_utils.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState> {
  final Logger _logger;
  final PredictUseCase _predictUseCase;
  final CravingsHistoryRepository _cravingsHistoryRepository;
  final IgnoredCravingsRepository _ignoredCravingsRepository;
  final AppSharedPreferences _appSharedPreferences;
  final FirebaseAppAnalytics _firebaseAppAnalytics;
  final DelayUtils _delayUtils;

  bool isDonNotShowCravingSatisfiedDialogAgain = false;

  bool _isDelayPredictingFinish = false;
  bool _isActualPredictingFinish = false;
  CravingModel? _predictedModel;

  HomeCubit(
    this._logger,
    this._predictUseCase,
    this._cravingsHistoryRepository,
    this._ignoredCravingsRepository,
    this._appSharedPreferences,
    this._firebaseAppAnalytics,
    this._delayUtils,
  ) : super(const HomeState.on()) {
    _logger.logFor(this);
  }

  @override
  Future<void> init() async {
    isDonNotShowCravingSatisfiedDialogAgain =
        await _appSharedPreferences.getValue<bool>(SharedPrefsKeys.doNotShowCravingSatisfiedDialogAgain) ?? false;
  }

  Future<void> predict() async {
    if (state.isPredicting) {
      return;
    }

    _predictedModel = null;
    _isDelayPredictingFinish = false;
    _isActualPredictingFinish = false;
    emit(state.copyWith(isPredicting: true));

    // create an actual delay to finish loading animation
    unawaited(_delayUtils.delay(const Duration(seconds: 1)).then((_) {
      _isDelayPredictingFinish = true;
      _finishPredicting();
    }));

    unawaited(_firebaseAppAnalytics.logEvent(name: AnalyticsEvents.eventPredict));
    // if there is a predicted craving, threat it as ignored and add to ignored cravings
    if (state.predictedCraving != null) {
      unawaited(_firebaseAppAnalytics.logEvent(
        name: AnalyticsEvents.eventIgnoreCraving,
        parameters: {
          AnalyticsEvents.paramCraving: state.predictedCraving!.name,
        },
      ));
      _logger.log(LogLevel.debug, 'ignoring craving: ${state.predictedCraving!.name}');
      await _ignoredCravingsRepository.insert(state.predictedCraving!);
    }

    final craving = await _predictUseCase.predict();

    _logger.log(LogLevel.info, 'final predicted craving: $craving');

    _isActualPredictingFinish = true;
    _predictedModel = craving;
    _finishPredicting();
  }

  Future<void> chooseCraving() async {
    if (state.predictedCraving != null) {
      unawaited(_firebaseAppAnalytics.logEvent(
        name: AnalyticsEvents.eventchooseCraving,
        parameters: {
          AnalyticsEvents.paramCraving: state.predictedCraving!.name,
        },
      ));
      await _cravingsHistoryRepository.insert(state.predictedCraving!);
      emit(state.copyWith(predictedCraving: null));
    }
  }

  Future<void> doNotShowCravingSatisfiedDialogAgain({required bool isDontShowAgain}) async {
    isDonNotShowCravingSatisfiedDialogAgain = isDontShowAgain;
    await _appSharedPreferences.setValue(SharedPrefsKeys.doNotShowCravingSatisfiedDialogAgain, isDontShowAgain);
  }

  void _finishPredicting() {
    if (_isActualPredictingFinish && _isDelayPredictingFinish) {
      emit(state.copyWith(predictedCraving: _predictedModel, isPredicting: false));
    }
  }
}
