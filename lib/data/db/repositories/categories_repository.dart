import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/core/repository.dart';
import 'package:kycravings/data/db/cravings_database.dart';
import 'package:kycravings/data/db/tables/category_table.dart';

abstract interface class CategoriesRepository implements Repository<CategoryTable, CategoryTableData> {}

@LazySingleton(as: CategoriesRepository)
class CategoriesRepositoryImpl extends BaseRepository<CravingsDatabase, CategoryTable, CategoryTableData>
    implements CategoriesRepository {
  CategoriesRepositoryImpl(super.attachedDatabase);
}
