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
    if (StringUtils.isNullOrEmpty(categoryName)) {
      emit(state.copyWith(showErrorEmptyCategory: true));
      return false;
    }

    // final category = await _categoriesRepository.insert(categoryName);
    return true;
  }

  void onCategoryChanged(String categoryName) {
    emit(state.copyWith(showErrorEmptyCategory: StringUtils.isNullOrEmpty(categoryName)));
  }
}
