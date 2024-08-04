import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/repositories/categories_repository.dart';
import 'package:kycravings/presentation/add_cravings/states/add_cravings_state.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';
import 'package:kycravings/presentation/shared/utils/string_utils.dart';

@injectable
class AddCravingsCubit extends BaseCubit<AddCravingsState> {
  final CategoriesRepository _categoriesRepository;
  AddCravingsCubit(
    this._categoriesRepository,
  ) : super(const AddCravingsState.on());

  @override
  Future<void> init() async {
    final categories = await _categoriesRepository.selectAll();
    emit(state.copyWith(categories: categories));
  }

  Future<void> add() async {}

  Future<bool> addCategory(String categoryName) async {
    if (!_isValidCategory(categoryName)) {
      return false;
    }

    final category = await _categoriesRepository.insert(categoryName);
    emit(state.copyWith(categories: state.categories.toList()..add(category)));
    return true;
  }

  void onAddCategory() {
    emit(state.copyWith(categoryError: CategoryError.none));
  }

  void onCategoryChanged(String categoryName) {
    _isValidCategory(categoryName);
  }

  void onLongPressCategory(int categoryId) {
    _categoriesRepository.remove(categoryId);
    emit(state.copyWith(categories: state.categories.where((category) => category.id != categoryId).toList()));
  }

  bool _isValidCategory(String categoryName) {
    if (StringUtils.isNullOrEmpty(categoryName)) {
      emit(state.copyWith(categoryError: CategoryError.empty));
      return false;
    } else if (state.categories.map((category) => category.name.toLowerCase()).contains(categoryName.toLowerCase())) {
      emit(state.copyWith(categoryError: CategoryError.duplicate));
      return false;
    } else {
      emit(state.copyWith(categoryError: CategoryError.none));
      return true;
    }
  }
}
