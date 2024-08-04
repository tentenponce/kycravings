import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kycravings/domain/models/category_model.dart';

part 'add_cravings_state.freezed.dart';

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
class AddCravingsState with _$AddCravingsState {
  const factory AddCravingsState.on({
    @Default(CategoryError.none) CategoryError categoryError,
    @Default(CravingError.none) CravingError cravingError,
    @Default([]) Iterable<CategoryModel> categories,
  }) = _AddCravingsState;
}
