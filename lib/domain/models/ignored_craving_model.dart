import 'dart:math';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kycravings/domain/models/craving_model.dart';

part 'ignored_craving_model.g.dart';

@CopyWith()
class IgnoredCravingModel extends Equatable {
  @visibleForTesting
  static IgnoredCravingModel test = IgnoredCravingModel(
    id: Random().nextInt(100),
    // ignore: invalid_use_of_visible_for_testing_member
    cravingModel: CravingModel.test,
    createdAt: DateTime.now(),
  );

  final int id;
  final CravingModel cravingModel;
  final DateTime createdAt;

  const IgnoredCravingModel({
    required this.id,
    required this.cravingModel,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        cravingModel,
        createdAt,
      ];
}
