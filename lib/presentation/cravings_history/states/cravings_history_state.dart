import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kycravings/domain/models/craving_history_model.dart';

part 'cravings_history_state.freezed.dart';

@freezed
class CravingsHistoryState with _$CravingsHistoryState {
  const factory CravingsHistoryState.on({
    @Default(false) bool isLoading,
    @Default(false) bool isScrollBottomLoading,
    @Default([]) Iterable<CravingHistoryModel> cravingsHistory,
  }) = _CravingsHistoryState;
}
