import 'package:injectable/injectable.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/repositories/cravings_history_repository.dart';
import 'package:kycravings/domain/use_cases/predict_use_case.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';
import 'package:kycravings/presentation/home/states/home_state.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState> {
  final Logger _logger;
  final PredictUseCase _predictUseCase;
  final CravingsHistoryRepository _cravingsHistoryRepository;
  HomeCubit(
    this._logger,
    this._predictUseCase,
    this._cravingsHistoryRepository,
  ) : super(const HomeState.on()) {
    _logger.logFor(this);
  }

  @override
  Future<void> init() async {}

  Future<void> predict() async {
    final craving = await _predictUseCase.predict();

    _logger.log(LogLevel.info, 'final predicted craving: $craving');

    emit(state.copyWith(predictedCraving: craving));
  }

  Future<void> chooseCraving() async {
    if (state.predictedCraving != null) {
      await _cravingsHistoryRepository.insert(state.predictedCraving!);
      emit(state.copyWith(predictedCraving: null));
    }
  }
}
