import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:kycravings/core/infrastructure/constants/analytics_events.dart';
import 'package:kycravings/core/infrastructure/platform/firebase_app_analytics.dart';
import 'package:kycravings/data/db/repositories/cravings_history_repository.dart';
import 'package:kycravings/data/db/repositories/cravings_repository.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/presentation/add_cravings_history/states/add_cravings_history_state.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';

@injectable
class AddCravingsHistoryCubit extends BaseCubit<AddCravingsHistoryState> {
  late void Function() onInitialLoad;

  final int _cravingLimit = 20;
  final CravingsRepository _cravingsRepository;
  final CravingsHistoryRepository _cravingsHistoryRepository;
  final FirebaseAppAnalytics _firebaseAppAnalytics;

  bool _isBottomReached = false;

  AddCravingsHistoryCubit(
    this._cravingsRepository,
    this._cravingsHistoryRepository,
    this._firebaseAppAnalytics,
  ) : super(const AddCravingsHistoryState.on());

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

  Future<void> onAddCravingHistory(CravingModel cravingModel, DateTime selectedDate) async {
    await _cravingsHistoryRepository.insert(cravingModel, createdAt: selectedDate);
    unawaited(_firebaseAppAnalytics.logEvent(
      name: AnalyticsEvents.eventAddCravingHistory,
      parameters: {AnalyticsEvents.paramCraving: cravingModel.name},
    ));
  }
}
