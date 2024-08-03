import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/core/repository.dart';
import 'package:kycravings/data/db/cravings_database.dart';
import 'package:kycravings/data/db/tables/craving_table.dart';
import 'package:kycravings/domain/models/category_model.dart';
import 'package:kycravings/domain/models/craving_model.dart';

abstract interface class CravingsRepository implements Repository<CravingTable, CravingTableData> {
  Future<List<CravingModel>> selectWithCategories();
}

@LazySingleton(as: CravingsRepository)
class CravingsRepositoryImpl extends BaseRepository<CravingsDatabase, CravingTable, CravingTableData>
    implements CravingsRepository {
  CravingsRepositoryImpl(super.attachedDatabase);

  @override
  Future<List<CravingModel>> selectWithCategories() async {
    const customQuery = 'SELECT '
        'craving_table.id as craving_id, '
        'craving_table.name as craving_name, '
        'category_table.id as category_id, '
        'category_table.name as category_name '
        'FROM craving_category_table '
        'LEFT JOIN craving_table ON craving_category_table.craving_id=craving_table.id '
        'LEFT JOIN category_table ON craving_category_table.category_id=category_table.id';

    final results = await customSelect(customQuery).get();

    // get unique cravings IDs
    final cravingIds = results.map((result) => result.read<int>('craving_id')).toSet().toList();

    return cravingIds.map((cravingId) {
      // get categories for each craving
      final categories = results.where((result) {
        return result.read<int>('craving_id') == cravingId;
      }).map((result) {
        final categoryId = result.read<int>('category_id');
        final categoryName = result.read<String>('category_name');
        return CategoryModel(id: categoryId, name: categoryName);
      });

      // get name of the craving ID
      final cravingName = results.firstWhere((result) {
        return result.read<int>('craving_id') == cravingId;
      }).read<String>('craving_name');

      return CravingModel(id: cravingId, name: cravingName, categories: categories);
    }).toList();
  }
}
