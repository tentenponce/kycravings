import 'package:injectable/injectable.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/repositories/cravings_history_repository.dart';
import 'package:kycravings/data/db/repositories/ignored_cravings_repository.dart';
import 'package:kycravings/domain/use_cases/predict_use_case.dart';
import 'package:kycravings/presentation/core/base/base_cubit.dart';
import 'package:kycravings/presentation/home/states/home_state.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState> {
  final Logger _logger;
  final PredictUseCase _predictUseCase;
  final CravingsHistoryRepository _cravingsHistoryRepository;
  final IgnoredCravingsRepository _ignoredCravingsRepository;
  HomeCubit(
    this._logger,
    this._predictUseCase,
    this._cravingsHistoryRepository,
    this._ignoredCravingsRepository,
  ) : super(const HomeState.on()) {
    _logger.logFor(this);
  }

  @override
  Future<void> init() async {
    final deletedCount = await _ignoredCravingsRepository.deletePreviousDays();
    _logger.log(LogLevel.info, 'deleted $deletedCount ignored cravings');
  }

  Future<void> predict() async {
    // if there is a predicted craving, threat it as ignored and add to ignored cravings
    if (state.predictedCraving != null) {
      _logger.log(LogLevel.debug, 'ignoring craving: ${state.predictedCraving!.name}');
      await _ignoredCravingsRepository.insert(state.predictedCraving!);
    }

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
