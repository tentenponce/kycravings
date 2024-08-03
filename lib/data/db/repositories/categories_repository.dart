import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/core/repository.dart';
import 'package:kycravings/data/db/cravings_database.dart';
import 'package:kycravings/data/db/tables/category_table.dart';
import 'package:kycravings/domain/models/category_model.dart';

abstract interface class CategoriesRepository implements Repository<CategoryTable, CategoryTableData> {
  Future<List<CategoryModel>> selectAll();
}

@LazySingleton(as: CategoriesRepository)
class CategoriesRepositoryImpl extends BaseRepository<CravingsDatabase, CategoryTable, CategoryTableData>
    implements CategoriesRepository {
  CategoriesRepositoryImpl(super.attachedDatabase);

  @override
  Future<List<CategoryModel>> selectAll() async {
    final categoriesData = await select(table).get();

    return categoriesData
        .map((categoryData) => CategoryModel(
              id: categoryData.id,
              name: categoryData.name,
            ))
        .toList();
  }
}
