import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kycravings/domain/models/category_model.dart';

part 'add_cravings_state.freezed.dart';

@freezed
class AddCravingsState with _$AddCravingsState {
  const factory AddCravingsState.on({
    @Default(false) bool showErrorEmptyCategory,
    @Default([]) Iterable<CategoryModel> categories,
  }) = _AddCravingsState;
}
