import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/repositories/cravings_history_repository.dart';
import 'package:kycravings/data/db/repositories/cravings_repository.dart';
import 'package:kycravings/data/db/repositories/ignored_cravings_repository.dart';
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
  final IgnoredCravingsRepository _ignoredCravingsRepository;
  final DateTimeUtils _dateTimeUtils;

  PredictUseCaseImpl(
    this._logger,
    this._cravingsRepository,
    this._cravingsHistoryRepository,
    this._ignoredCravingsRepository,
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

      scoredItems[craving] = score;
    }

    final sortedCravingScores = scoredItems.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    // get the craving with the lowest score as it is highly likely
    // to crave for something that has not been eaten for a long time
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

  /// highest score will determine based on:
  /// the food has been eaten recently
  /// the food has been craved many times
  /// the food has been ignored many times
  Future<double> _getCravingScore(CravingModel craving) async {
    final cravingPreferences = await _cravingsHistoryRepository.cravingPreferences();
    final ignoredCravingsPreferences = await _ignoredCravingsRepository.ignoredCravings();

    var ignoredCravingCount = 0;
    for (final ignoredCraving in ignoredCravingsPreferences) {
      if (ignoredCraving.cravingModel.id == craving.id) {
        ignoredCravingCount = ignoredCraving.preferenceCount;
        break;
      }
    }
    _logger.log(LogLevel.info, '${craving.name} ignored count: $ignoredCravingCount');

    var decayScore = 0.0;
    // Calculate score for each craving based on history
    for (final cravingPreference in cravingPreferences) {
      if (cravingPreference.cravingModel.id == craving.id) {
        _logger.log(LogLevel.info, '${craving.name} preferred count: ${cravingPreference.preferenceCount}');

        final decay = _decayFactor(cravingPreference.lastChosen!);
        _logger.log(LogLevel.info, '${craving.name} decay factor: $decay');

        decayScore = cravingPreference.preferenceCount * decay;
        break;
      }
    }

    // add how many times the user chosen the craving and how many times the user ignored the craving
    final totalScore = ignoredCravingCount + decayScore;

    _logger.log(LogLevel.info, '${craving.name} total score: $totalScore');

    return totalScore;
  }

  /// calculate the decay factor exponentially
  double _decayFactor(DateTime lastChosen) {
    final duration = _dateTimeUtils.now().difference(lastChosen).inDays + 1;

    return exp(-0.1 * duration);
  }
}
