import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/repositories/categories_repository.dart';
import 'package:kycravings/data/db/repositories/cravings_repository.dart';
import 'package:kycravings/domain/models/category_model.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';
import 'package:kycravings/presentation/shared/utils/debouncer_utils.dart';
import 'package:kycravings/presentation/shared/utils/string_utils.dart';
import 'package:kycravings/presentation/update_cravings/states/update_cravings_state.dart';

@injectable
class UpdateCravingsCubit extends BaseCubit<UpdateCravingsState> {
  final CravingsRepository _cravingsRepository;
  final CategoriesRepository _categoriesRepository;
  final DebouncerUtils _debouncerUtils;

  UpdateCravingsCubit(
    this._cravingsRepository,
    this._categoriesRepository,
    this._debouncerUtils,
  ) : super(UpdateCravingsState.on(cravingModel: CravingModel.empty));

  @override
  Future<void> init() async {
    _debouncerUtils.setMilliseconds(500);
  }

  @override
  set arguments(Object? arguments) {
    super.arguments = arguments;
    final cravingModel = arguments! as CravingModel;

    _setCravingModelArument(cravingModel);
  }

  Future<bool> updateCraving(String updatedCravingName) async {
    if (!await _isValidCraving(updatedCravingName)) {
      return false;
    }

    await _cravingsRepository.replace(state.cravingModel.copyWith(
      name: updatedCravingName,
      categories: state.categories.where((category) => category.isSelected ?? false),
    ));

    return true;
  }

  void deleteCraving() {
    _cravingsRepository.remove(state.cravingModel.id);
  }

  void onCategoryChanged(String categoryName) {
    _isValidCategory(categoryName);
  }

  void onLongPressCategory(int categoryId) {
    _categoriesRepository.remove(categoryId);
    emit(state.copyWith(categories: state.categories.where((category) => category.id != categoryId).toList()));
  }

  void onAddCategory() {
    emit(state.copyWith(categoryError: CategoryError.none));
  }

  void onCravingChanged(String cravingName) {
    _debouncerUtils.run(() async => _isValidCraving(cravingName));
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

  Future<bool> _isValidCraving(String cravingName) async {
    if (StringUtils.isNullOrEmpty(cravingName)) {
      emit(state.copyWith(cravingError: CravingError.empty));
      return false;
    }

    final sameCraving = await _cravingsRepository.getCravingByName(cravingName);
    // if existing and not the same craving
    if (sameCraving != null && sameCraving.id != state.cravingModel.id) {
      emit(state.copyWith(cravingError: CravingError.duplicate));
      return false;
    }

    emit(state.copyWith(cravingError: CravingError.none));
    return true;
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

  Future<void> _setCravingModelArument(CravingModel cravingModel) async {
    final categories = await _categoriesRepository.selectAll();

    emit(state.copyWith(
      cravingModel: cravingModel,
      // set categories with isSelected based on the selected categories of the cravingModel
      categories: categories.map(
        (category) =>
            category.copyWith(isSelected: cravingModel.categories.map((category) => category.id).contains(category.id)),
      ),
    ));
  }
}
