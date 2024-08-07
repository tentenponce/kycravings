import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/core/repository.dart';
import 'package:kycravings/data/db/cravings_database.dart';
import 'package:kycravings/data/db/tables/craving_category_table.dart';
import 'package:kycravings/domain/models/category_model.dart';

abstract interface class CravingCategoryRepository
    implements Repository<CravingCategoryTable, CravingCategoryTableData> {
  /// this is a custom query to select all categories and their craving IDs
  Future<Iterable<(CategoryModel, int)>> selectAll();
  Future<void> insertAll(Iterable<(int, int)> cravingCategoryMap);
  Future<int> deleteByCravingId(int cravingId);
  Future<int> deleteByCategoryId(int categoryId);
}

@LazySingleton(as: CravingCategoryRepository)
class CravingCategoryRepositoryImpl
    extends BaseRepository<CravingsDatabase, CravingCategoryTable, CravingCategoryTableData>
    implements CravingCategoryRepository {
  CravingCategoryRepositoryImpl(super.attachedDatabase);

  @override
  Future<Iterable<(CategoryModel, int)>> selectAll() async {
    const customQuery = 'SELECT '
        'craving_category_table.craving_id as craving_id, '
        'category_table.id as category_id, '
        'category_table.name as category_name, '
        'category_table.created_at as category_created_at, '
        'category_table.updated_at as category_updated_at '
        'FROM craving_category_table '
        'LEFT JOIN category_table ON craving_category_table.category_id=category_table.id ';

    final results = await customSelect(customQuery).get();

    return results.map((result) {
      final category = CategoryModel(
        id: result.read<int>('category_id'),
        name: result.read<String>('category_name'),
        createdAt: result.read<DateTime>('category_created_at'),
        updatedAt: result.read<DateTime>('category_updated_at'),
      );
      final cravingId = result.read<int>('craving_id');
      return (category, cravingId);
    });
  }

  @override
  Future<void> insertAll(Iterable<(int, int)> cravingCategoryMap) {
    return batch((batch) {
      batch.insertAll(table, cravingCategoryMap.map((entry) {
        return CravingCategoryTableCompanion(
          cravingId: Value(entry.$1),
          categoryId: Value(entry.$2),
        );
      }));
    });
  }

  @override
  Future<int> deleteByCravingId(int cravingId) {
    return (delete(table)..where((t) => t.cravingId.equals(cravingId))).go();
  }

  @override
  Future<int> deleteByCategoryId(int categoryId) {
    return (delete(table)..where((t) => t.categoryId.equals(categoryId))).go();
  }
}
