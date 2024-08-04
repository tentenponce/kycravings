import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/core/repository.dart';
import 'package:kycravings/data/db/cravings_database.dart';
import 'package:kycravings/data/db/repositories/craving_category_repository.dart';
import 'package:kycravings/data/db/tables/craving_table.dart';
import 'package:kycravings/domain/models/category_model.dart';
import 'package:kycravings/domain/models/craving_model.dart';

abstract interface class CravingsRepository implements Repository<CravingTable, CravingTableData> {
  Future<CravingModel> insert(String cravingName, Iterable<CategoryModel> categories);
  Future<List<CravingModel>> selectWithCategories();

  /// get craving without categories
  Future<CravingModel?> getCravingByName(String cravingName);
  void remove(int id);
}

@LazySingleton(as: CravingsRepository)
class CravingsRepositoryImpl extends BaseRepository<CravingsDatabase, CravingTable, CravingTableData>
    implements CravingsRepository {
  final Logger _logger;
  final CravingCategoryRepository _cravingCategoryRepository;

  CravingsRepositoryImpl(
    this._logger,
    this._cravingCategoryRepository,
    super.attachedDatabase,
  ) {
    _logger.logFor(this);
  }

  @override
  Future<CravingModel> insert(String cravingName, Iterable<CategoryModel> categories) async {
    _logger.log(
      LogLevel.debug,
      'inserting craving $cravingName with categories ${categories.map((category) => category.name)}',
    );
    final id = await into(table).insert(
      CravingTableCompanion(
        name: Value(cravingName),
      ),
    );

    _logger.log(LogLevel.debug, 'successful inserted craving $cravingName with id $id');

    final cravingCategoryMap = categories.map((category) {
      return (id, category.id);
    });

    _logger.log(LogLevel.debug, 'inserting categories $cravingCategoryMap for craving $cravingName');

    await _cravingCategoryRepository.insertAll(cravingCategoryMap);

    _logger.log(LogLevel.debug, 'successful inserted categories for craving $cravingName');

    return CravingModel(
      id: id,
      name: cravingName,
      categories: categories,
    );
  }

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

  @override
  Future<CravingModel?> getCravingByName(String cravingName) async {
    final result = await (select(table)..where((tbl) => tbl.name.like(cravingName))).getSingleOrNull();

    if (result == null) {
      return null;
    }

    return CravingModel(id: result.id, name: result.name, categories: const []);
  }

  @override
  Future<int> remove(int id) async {
    await _cravingCategoryRepository.deleteByCravingId(id);
    return (delete(table)..where((t) => t.id.equals(id))).go();
  }
}
