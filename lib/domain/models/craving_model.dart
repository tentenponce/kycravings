import 'package:equatable/equatable.dart';
import 'package:kycravings/domain/models/category_model.dart';

class CravingModel extends Equatable {
  final int id;
  final String name;
  final Iterable<CategoryModel> categories;

  const CravingModel({
    required this.id,
    required this.name,
    required this.categories,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        categories,
      ];
}
