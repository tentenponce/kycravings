import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/repositories/cravings_repository.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';
import 'package:kycravings/presentation/your_cravings/states/your_cravings_state.dart';

@injectable
class YourCravingsCubit extends BaseCubit<YourCravingsState> {
  final CravingsRepository _cravingsRepository;

  YourCravingsCubit(this._cravingsRepository) : super(const YourCravingsState.on());

  @override
  Future<void> init() async {
    await getCravings();
  }

  Future<void> getCravings() async {
    final cravings = await _cravingsRepository.selectWithCategories();
    emit(state.copyWith(cravings: cravings));
  }
}
