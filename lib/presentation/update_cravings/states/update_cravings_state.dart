import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kycravings/domain/models/category_model.dart';
import 'package:kycravings/domain/models/craving_model.dart';

part 'update_cravings_state.freezed.dart';

enum CategoryError {
  empty,
  duplicate,
  none,
}

enum CravingError {
  empty,
  duplicate,
  none,
}

@freezed
class UpdateCravingsState with _$UpdateCravingsState {
  const factory UpdateCravingsState.on({
    required CravingModel cravingModel,
    @Default(CategoryError.none) CategoryError categoryError,
    @Default(CravingError.none) CravingError cravingError,
    @Default([]) Iterable<CategoryModel> categories,
  }) = _UpdateCravingsState;
}
