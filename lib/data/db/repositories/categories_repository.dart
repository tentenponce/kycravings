import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/core/repository.dart';
import 'package:kycravings/data/db/cravings_database.dart';
import 'package:kycravings/data/db/repositories/craving_category_repository.dart';
import 'package:kycravings/data/db/tables/category_table.dart';
import 'package:kycravings/domain/models/category_model.dart';

abstract interface class CategoriesRepository implements Repository<CategoryTable, CategoryTableData> {
  Future<List<CategoryModel>> selectAll();
  Future<CategoryModel> insert(String categoryName);
  void remove(int id);
}

@LazySingleton(as: CategoriesRepository)
class CategoriesRepositoryImpl extends BaseRepository<CravingsDatabase, CategoryTable, CategoryTableData>
    implements CategoriesRepository {
  final CravingCategoryRepository _cravingCategoryRepository;

  CategoriesRepositoryImpl(
    this._cravingCategoryRepository,
    super.attachedDatabase,
  );

  @override
  Future<List<CategoryModel>> selectAll() async {
    final categoriesData = await select(table).get();

    return categoriesData
        .map((categoryData) => CategoryModel(
              id: categoryData.id,
              name: categoryData.name,
              createdAt: categoryData.createdAt,
              updatedAt: categoryData.updatedAt,
            ))
        .toList();
  }

  @override
  Future<CategoryModel> insert(String categoryName) async {
    final addedCategoryData = await into(table).insertReturning(
      CategoryTableCompanion(
        name: Value(categoryName),
      ),
    );

    return CategoryModel(
      id: addedCategoryData.id,
      name: categoryName,
      createdAt: addedCategoryData.createdAt,
      updatedAt: addedCategoryData.updatedAt,
    );
  }

  @override
  Future<int> remove(int id) async {
    await _cravingCategoryRepository.deleteByCategoryId(id);
    return (delete(table)..where((t) => t.id.equals(id))).go();
  }
}
