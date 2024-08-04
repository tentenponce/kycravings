import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'category_model.g.dart';

@CopyWith()
class CategoryModel extends Equatable {
  @visibleForTesting
  static CategoryModel empty = CategoryModel(
    id: 0,
    name: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  final int id;
  final String name;
  final bool? isSelected;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.isSelected,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        isSelected,
        createdAt,
        updatedAt,
      ];
}
