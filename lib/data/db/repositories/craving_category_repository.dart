import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/core/repository.dart';
import 'package:kycravings/data/db/cravings_database.dart';
import 'package:kycravings/data/db/tables/craving_category_table.dart';

abstract interface class CravingCategoryRepository
    implements Repository<CravingCategoryTable, CravingCategoryTableData> {
  Future<void> insertAll(Map<int, int> cravingCategoryMap);
}

@LazySingleton(as: CravingCategoryRepository)
class CravingCategoryRepositoryImpl
    extends BaseRepository<CravingsDatabase, CravingCategoryTable, CravingCategoryTableData>
    implements CravingCategoryRepository {
  CravingCategoryRepositoryImpl(super.attachedDatabase);

  @override
  Future<void> insertAll(Map<int, int> cravingCategoryMap) {
    return batch((batch) {
      batch.insertAll(table, cravingCategoryMap.entries.map((entry) {
        return CravingCategoryTableData(
          cravingId: entry.key,
          categoryId: entry.value,
        );
      }));
    });
  }
}
