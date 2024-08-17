import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kycravings/domain/models/craving_model.dart';

part 'home_state.freezed.dart';

enum HomeAppTutorial {
  predict,
  satisfied,
  drawer,
}

@freezed
class HomeState with _$HomeState {
  const factory HomeState.on({
    @Default(null) CravingModel? predictedCraving,
    @Default(false) bool isPredicting,
    @Default(false) bool isSwipePredicting,
    @Default(null) HomeAppTutorial? tutorial,
  }) = _HomeState;
}
