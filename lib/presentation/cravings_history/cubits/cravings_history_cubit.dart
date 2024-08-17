import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/repositories/cravings_history_repository.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';
import 'package:kycravings/presentation/cravings_history/states/cravings_history_state.dart';

@injectable
class CravingsHistoryCubit extends BaseCubit<CravingsHistoryState> {
  late void Function() onInitialLoad;

  final int _historyLimit = 15;
  final CravingsHistoryRepository _cravingsHistoryRepository;

  bool _isBottomReached = false;

  CravingsHistoryCubit(
    this._cravingsHistoryRepository,
  ) : super(const CravingsHistoryState.on());

  @override
  Future<void> init() async {
    await getCravings();
    onInitialLoad();
  }

  Future<void> getCravings() async {
    emit(state.copyWith(isLoading: true));
    _isBottomReached = false;
    final cravingHistory = await _cravingsHistoryRepository.selectAll(
      limit: _historyLimit,
      offset: 0,
    );

    emit(state.copyWith(cravingsHistory: cravingHistory, isLoading: false));
  }

  Future<void> onScrollBottom() async {
    if (_isBottomReached || state.isScrollBottomLoading || state.isLoading) {
      return;
    }

    emit(state.copyWith(isScrollBottomLoading: true));
    final cravingHistory = await _cravingsHistoryRepository.selectAll(
      limit: _historyLimit,
      offset: state.cravingsHistory.length,
    );

    if (cravingHistory.isEmpty) {
      _isBottomReached = true;
      emit(state.copyWith(isScrollBottomLoading: false));
      return;
    }

    emit(state.copyWith(
      cravingsHistory: state.cravingsHistory.toList() + cravingHistory.toList(),
      isScrollBottomLoading: false,
    ));
  }

  void onCravingDelete(int cravingHistoryId) {
    _cravingsHistoryRepository.remove(cravingHistoryId);
    emit(state.copyWith(
        cravingsHistory: state.cravingsHistory.where((craving) => craving.id != cravingHistoryId).toList()));
  }
}
