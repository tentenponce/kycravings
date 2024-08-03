import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kycravings/domain/models/craving_model.dart';

part 'your_cravings_state.freezed.dart';

@freezed
class YourCravingsState with _$YourCravingsState {
  const factory YourCravingsState({
    @Default([]) List<CravingModel> cravings,
  }) = _YourCravingsState;
}
