import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/converters/category_converter.dart';
import 'package:kycravings/data/db/core/dto_converter.dart';
import 'package:kycravings/data/db/cravings_database.dart';
import 'package:kycravings/domain/models/craving_model.dart';

@lazySingleton
class CravingConverter extends DtoConverter<CravingModel, CravingTableData> {
  final CategoryConverter _categoryConverter;

  CravingConverter(this._categoryConverter);

  @override
  Future<CravingTableData> convert(CravingModel dto) async {
    return CravingTableData(
      id: dto.id,
      name: dto.name,
    );
  }

  @override
  Future<CravingModel> convertBack(CravingTableData dbObj) async {
    return CravingModel(
      id: dbObj.id,
      name: dbObj.name,
      categories: const [],
    );
  }

  Future<CravingModel> convertWithCategories(
    CravingTableData dbObj,
    Iterable<CategoryTableData> categoriesData,
  ) async {
    final categories = await _categoryConverter.convertBackList(categoriesData);
    return CravingModel(
      id: dbObj.id,
      name: dbObj.name,
      categories: categories,
    );
  }
}
