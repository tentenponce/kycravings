import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/core/dto_converter.dart';
import 'package:kycravings/data/db/cravings_database.dart';
import 'package:kycravings/domain/models/category_model.dart';

@lazySingleton
class CategoryConverter extends DtoConverter<CategoryModel, CategoryTableData> {
  @override
  Future<CategoryTableData> convert(CategoryModel dto) async {
    return CategoryTableData(
      id: dto.id,
      name: dto.name,
    );
  }

  @override
  Future<CategoryModel> convertBack(CategoryTableData dbObj) async {
    return CategoryModel(
      id: dbObj.id,
      name: dbObj.name,
    );
  }
}
