import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:kycravings/core/infrastructure/constants/analytics_events.dart';
import 'package:kycravings/core/infrastructure/platform/firebase_app_analytics.dart';
import 'package:kycravings/data/db/repositories/cravings_repository.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';
import 'package:kycravings/presentation/your_cravings/states/your_cravings_state.dart';

@injectable
class YourCravingsCubit extends BaseCubit<YourCravingsState> {
  late void Function() onInitialLoad;

  final int _cravingLimit = 20;
  final CravingsRepository _cravingsRepository;
  final FirebaseAppAnalytics _firebaseAppAnalytics;

  bool _isBottomReached = false;

  YourCravingsCubit(
    this._cravingsRepository,
    this._firebaseAppAnalytics,
  ) : super(const YourCravingsState.on());

  @override
  Future<void> init() async {
    await getCravings();
    onInitialLoad();
  }

  Future<void> getCravings() async {
    emit(state.copyWith(isLoading: true));
    _isBottomReached = false;
    final cravings = await _cravingsRepository.selectWithCategories(
      limit: _cravingLimit,
      offset: 0,
    );
    emit(state.copyWith(cravings: cravings, isLoading: false));
  }

  Future<void> onScrollBottom() async {
    if (_isBottomReached || state.isScrollBottomLoading || state.isLoading) {
      return;
    }

    emit(state.copyWith(isScrollBottomLoading: true));
    final cravings = await _cravingsRepository.selectWithCategories(
      limit: _cravingLimit,
      offset: state.cravings.length,
    );

    if (cravings.isEmpty) {
      _isBottomReached = true;
      emit(state.copyWith(isScrollBottomLoading: false));
      return;
    }

    emit(state.copyWith(
      cravings: state.cravings.toList() + cravings.toList(),
      isScrollBottomLoading: false,
    ));
  }

  Future<void> onCravingDelete(int cravingId) async {
    await _cravingsRepository.remove(cravingId);
    final removedCraving = state.cravings.firstWhere((craving) => craving.id == cravingId);
    unawaited(_firebaseAppAnalytics.logEvent(
      name: AnalyticsEvents.eventDeleteCraving,
      parameters: {AnalyticsEvents.paramCraving: removedCraving.name},
    ));
    emit(state.copyWith(cravings: state.cravings.where((craving) => craving.id != cravingId).toList()));
  }
}
