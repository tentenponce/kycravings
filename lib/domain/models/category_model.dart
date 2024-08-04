import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'category_model.g.dart';

@CopyWith()
class CategoryModel extends Equatable {
  final int id;
  final String name;
  final bool? isSelected;

  const CategoryModel({
    required this.id,
    required this.name,
    this.isSelected,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        isSelected,
      ];
}
