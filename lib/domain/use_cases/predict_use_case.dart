import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/repositories/cravings_history_repository.dart';
import 'package:kycravings/data/db/repositories/cravings_repository.dart';
import 'package:kycravings/domain/core/utils/date_time_utils.dart';
import 'package:kycravings/domain/models/craving_model.dart';

abstract interface class PredictUseCase {
  Future<CravingModel> predict();
}

@LazySingleton(as: PredictUseCase)
class PredictUseCaseImpl implements PredictUseCase {
  final Logger _logger;
  final CravingsRepository _cravingsRepository;
  final CravingsHistoryRepository _cravingsHistoryRepository;
  final DateTimeUtils _dateTimeUtils;

  PredictUseCaseImpl(
    this._logger,
    this._cravingsRepository,
    this._cravingsHistoryRepository,
    this._dateTimeUtils,
  ) {
    _logger.logFor(this);
  }

  @override
  Future<CravingModel> predict() async {
    final cravings = await _cravingsRepository.selectWithCategories();
    final scoredItems = <CravingModel, double>{};

    for (final craving in cravings) {
      final score = await _getCravingScore(craving);

      _logger.log(LogLevel.info, '${craving.name} score: $score');
      scoredItems[craving] = score;
    }

    final sortedCravingScores = scoredItems.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    final predictedCraving = sortedCravingScores.last;

    _logger.log(LogLevel.info, 'initial predicted craving: $predictedCraving');

    // get the cravings with the same score of the predicted craving
    final sameScoredCravings =
        sortedCravingScores.where((cravingScore) => cravingScore.value == predictedCraving.value).toList();

    _logger.log(
      LogLevel.info,
      '${predictedCraving.key.name} with same score: ${sameScoredCravings.map((sameScoredCraving) => sameScoredCraving.key.name)}',
    );

    if (sameScoredCravings.length > 1) {
      final randomScoredIndex = Random().nextInt(sameScoredCravings.length);
      _logger.log(LogLevel.info, 'Randomly selecting from same scored cravings: $randomScoredIndex');
      return sameScoredCravings[randomScoredIndex].key;
    }

    return predictedCraving.key;
  }

  Future<double> _getCravingScore(CravingModel craving) async {
    final cravingPreferences = await _cravingsHistoryRepository.cravingPreferences();
    var score = 0.0;

    _logger.log(LogLevel.info, '${craving.name} calculating score...');
    // Calculate score for each craving based on history
    for (final cravingPreference in cravingPreferences) {
      if (cravingPreference.cravingModel.id == craving.id) {
        _logger.log(LogLevel.info, '${craving.name} preference: $cravingPreference');

        final decay = _decayFactor(cravingPreference.lastChosen);
        _logger.log(LogLevel.info, '${craving.name} decay factor: $decay');

        score = cravingPreference.historyCount * decay;
        break;
      }
    }

    return score;
  }

  /// calculate the decay factor exponentially
  double _decayFactor(DateTime lastChosen) {
    final duration = _dateTimeUtils.now().difference(lastChosen).inDays;

    return exp(-0.1 * duration);
  }
}
