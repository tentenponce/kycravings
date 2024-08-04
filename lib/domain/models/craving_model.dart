import 'dart:math';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kycravings/domain/models/category_model.dart';

part 'craving_model.g.dart';

@CopyWith()
class CravingModel extends Equatable {
  static CravingModel empty = CravingModel(
    id: 0,
    name: '',
    categories: const [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  @visibleForTesting
  static CravingModel test = CravingModel(
    id: Random().nextInt(100),
    name: 'sample craving',
    categories: const [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  final int id;
  final String name;
  final Iterable<CategoryModel> categories;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CravingModel({
    required this.id,
    required this.name,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        categories,
        createdAt,
        updatedAt,
      ];
}
