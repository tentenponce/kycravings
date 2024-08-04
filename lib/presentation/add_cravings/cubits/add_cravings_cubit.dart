import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/repositories/categories_repository.dart';
import 'package:kycravings/data/db/repositories/cravings_repository.dart';
import 'package:kycravings/domain/models/category_model.dart';
import 'package:kycravings/presentation/add_cravings/states/add_cravings_state.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';
import 'package:kycravings/presentation/shared/utils/debouncer_utils.dart';
import 'package:kycravings/presentation/shared/utils/string_utils.dart';

@injectable
class AddCravingsCubit extends BaseCubit<AddCravingsState> {
  final CravingsRepository _cravingsRepository;
  final CategoriesRepository _categoriesRepository;
  final DebouncerUtil _debouncerUtil;
  AddCravingsCubit(
    this._cravingsRepository,
    this._categoriesRepository,
    this._debouncerUtil,
  ) : super(const AddCravingsState.on());

  @override
  Future<void> init() async {
    _debouncerUtil.setMilliseconds(500);

    final categories = await _categoriesRepository.selectAll();
    emit(state.copyWith(categories: categories));
  }

  Future<bool> addCraving(String cravingName) async {
    if (!await _isValidCraving(cravingName)) {
      return false;
    }

    await _cravingsRepository.insert(cravingName, state.categories);
    return true;
  }

  void onCravingChanged(String cravingName) {
    _debouncerUtil.run(() async => _isValidCraving(cravingName));
  }

  void onCategoryClick(int categoryId) {
    emit(state.copyWith(
        categories: state.categories.map((category) {
      if (category.id == categoryId) {
        return category.copyWith(isSelected: !(category.isSelected ?? false));
      } else {
        return category;
      }
    }).toList()));
  }

  Future<bool> addCategory(String categoryName) async {
    if (!_isValidCategory(categoryName)) {
      return false;
    }

    final category = await _categoriesRepository.insert(categoryName);
    emit(state.copyWith(categories: state.categories.toList()..add(category.copyWith(isSelected: true))));
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

  Future<bool> _isValidCraving(String cravingName) async {
    final sameCraving = await _cravingsRepository.getCravingByName(cravingName);

    if (StringUtils.isNullOrEmpty(cravingName)) {
      emit(state.copyWith(cravingError: CravingError.empty));
      return false;
    } else if (sameCraving != null) {
      emit(state.copyWith(cravingError: CravingError.duplicate));
      return false;
    } else {
      emit(state.copyWith(cravingError: CravingError.none));
      return true;
    }
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
