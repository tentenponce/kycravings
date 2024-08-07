import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/repositories/cravings_history_repository.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';
import 'package:kycravings/presentation/cravings_history/states/cravings_history_state.dart';

@injectable
class CravingsHistoryCubit extends BaseCubit<CravingsHistoryState> {
  final CravingsHistoryRepository _cravingsHistoryRepository;

  CravingsHistoryCubit(
    this._cravingsHistoryRepository,
  ) : super(const CravingsHistoryState.on());

  @override
  Future<void> init() async {
    final cravingHistory = await _cravingsHistoryRepository.selectAll();
    emit(state.copyWith(cravingsHistory: cravingHistory));
  }

  void onCravingDelete(int cravingHistoryId) {
    _cravingsHistoryRepository.remove(cravingHistoryId);
    emit(state.copyWith(
        cravingsHistory: state.cravingsHistory.where((craving) => craving.id != cravingHistoryId).toList()));
  }
}
