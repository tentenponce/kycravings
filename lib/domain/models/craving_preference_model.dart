import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:kycravings/domain/models/craving_model.dart';

part 'craving_preference_model.g.dart';

@CopyWith()
class CravingPreferenceModel extends Equatable {
  final CravingModel cravingModel;
  final int historyCount;
  final DateTime lastChosen;

  const CravingPreferenceModel({
    required this.cravingModel,
    required this.historyCount,
    required this.lastChosen,
  });

  @override
  List<Object?> get props => [
        cravingModel,
        historyCount,
        lastChosen,
      ];
}
