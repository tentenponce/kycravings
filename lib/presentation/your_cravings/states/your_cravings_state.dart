import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kycravings/domain/models/craving_model.dart';

part 'your_cravings_state.freezed.dart';

@freezed
class YourCravingsState with _$YourCravingsState {
  const factory YourCravingsState.on({
    @Default(false) bool isLoading,
    @Default(false) bool isScrollBottomLoading,
    @Default([]) List<CravingModel> cravings,
  }) = _YourCravingsState;
}
