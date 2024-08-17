import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kycravings/domain/models/craving_model.dart';

part 'add_cravings_history_state.freezed.dart';

@freezed
class AddCravingsHistoryState with _$AddCravingsHistoryState {
  const factory AddCravingsHistoryState.on({
    @Default(false) bool isLoading,
    @Default(false) bool isScrollBottomLoading,
    @Default([]) Iterable<CravingModel> cravings,
  }) = _AddCravingsHistoryState;
}
