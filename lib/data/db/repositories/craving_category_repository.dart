import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/core/repository.dart';
import 'package:kycravings/data/db/cravings_database.dart';
import 'package:kycravings/data/db/tables/craving_category_table.dart';

abstract interface class CravingCategoryRepository
    implements Repository<CravingCategoryTable, CravingCategoryTableData> {
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
