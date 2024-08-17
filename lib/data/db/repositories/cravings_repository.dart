import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:kycravings/core/logging/logger.dart';
import 'package:kycravings/data/db/core/repository.dart';
import 'package:kycravings/data/db/cravings_database.dart';
import 'package:kycravings/data/db/repositories/craving_category_repository.dart';
import 'package:kycravings/data/db/repositories/cravings_history_repository.dart';
import 'package:kycravings/data/db/repositories/ignored_cravings_repository.dart';
import 'package:kycravings/data/db/tables/craving_table.dart';
import 'package:kycravings/data/responses/craving_response.dart';
import 'package:kycravings/domain/models/category_model.dart';
import 'package:kycravings/domain/models/craving_model.dart';

abstract interface class CravingsRepository implements Repository<CravingTable, CravingTableData> {
  Future<List<CravingModel>> selectWithCategories({
    int? limit,
    int? offset,
    int? categoryFilter,
  });

  /// get craving without categories
  Future<CravingModel?> getCravingByName(String cravingName);
  Future<CravingModel> insert(String cravingName, Iterable<CategoryModel> categories);
  Future<void> insertAll(Iterable<CravingResponse> cravings);
  Future<void> replace(CravingModel updatedCravingModel);

  /// remove craving and its categories on craving category junction table
  void remove(int id);
}

@LazySingleton(as: CravingsRepository)
class CravingsRepositoryImpl extends BaseRepository<CravingsDatabase, CravingTable, CravingTableData>
    implements CravingsRepository {
  final Logger _logger;
  final CravingCategoryRepository _cravingCategoryRepository;
  final CravingsHistoryRepository _cravingsHistoryRepository;
  final IgnoredCravingsRepository _ignoredCravingsRepository;

  CravingsRepositoryImpl(
    this._logger,
    this._cravingCategoryRepository,
    this._cravingsHistoryRepository,
    this._ignoredCravingsRepository,
    super.attachedDatabase,
  ) {
    _logger.logFor(this);
  }

  @override
  Future<List<CravingModel>> selectWithCategories({
    int? limit,
    int? offset,
    int? categoryFilter,
  }) async {
    final categoryFilterQuery = 'WHERE craving_id IN '
        '(SELECT craving_table.id FROM craving_table '
        'LEFT JOIN craving_category_table ON craving_table.id=craving_category_table.craving_id '
        'WHERE craving_category_table.category_id=$categoryFilter) ';

    final cravingCustomQuery = 'SELECT '
        'craving_table.id as craving_id, '
        'craving_table.name as craving_name, '
        'craving_table.created_at as craving_created_at, '
        'craving_table.updated_at as craving_updated_at '
        'FROM craving_table '
        '${categoryFilter != null ? categoryFilterQuery : ''} '
        'ORDER BY craving_table.created_at DESC '
        '${limit != null ? 'LIMIT $limit ' : ''}'
        '${offset != null ? 'OFFSET $offset ' : ''}';

    final categoryCustomQuery = 'SELECT '
        'craving_table.id as craving_id, '
        'category_table.id as category_id, '
        'category_table.name as category_name, '
        'category_table.created_at as category_created_at, '
        'category_table.updated_at as category_updated_at '
        'FROM craving_category_table '
        'LEFT JOIN craving_table ON craving_category_table.craving_id=craving_table.id '
        'LEFT JOIN category_table ON craving_category_table.category_id=category_table.id '
        '${categoryFilter != null ? categoryFilterQuery : ''} '
        'ORDER BY craving_table.created_at DESC ';

    _logger.log(LogLevel.debug, 'cravingCustomQuery: $cravingCustomQuery');
    _logger.log(LogLevel.debug, 'categoryCustomQuery: $categoryCustomQuery');

    final cravingResults = await customSelect(cravingCustomQuery).get();
    final categoryResults = await customSelect(categoryCustomQuery).get();

    return cravingResults.map((cravingResult) {
      final cravingId = cravingResult.read<int>('craving_id');
      final cravingName = cravingResult.read<String>('craving_name');
      final cravingCreatedAt = cravingResult.read<DateTime>('craving_created_at');
      final cravingUpdatedAt = cravingResult.read<DateTime>('craving_updated_at');

      // get categories for each craving
      final categories = categoryResults
          .where((result) {
            return result.read<int>('craving_id') == cravingId;
          })
          // cravings without categories are allowed so filter null category ids
          .where((result) => result.read<int?>('category_id') != null)
          .map((result) {
            final categoryId = result.read<int>('category_id');
            final categoryName = result.read<String>('category_name');
            final categoryCreatedAt = result.read<DateTime>('category_created_at');
            final categoryUpdatedAt = result.read<DateTime>('category_updated_at');
            return CategoryModel(
              id: categoryId,
              name: categoryName,
              createdAt: categoryCreatedAt,
              updatedAt: categoryUpdatedAt,
            );
          });

      return CravingModel(
        id: cravingId,
        name: cravingName,
        categories: categories,
        createdAt: cravingCreatedAt,
        updatedAt: cravingUpdatedAt,
      );
    }).toList();
  }

  @override
  Future<CravingModel?> getCravingByName(String cravingName) async {
    final result = await (select(table)..where((tbl) => tbl.name.like(cravingName))).getSingleOrNull();

    if (result == null) {
      return null;
    }

    return CravingModel(
      id: result.id,
      name: result.name,
      categories: const [],
      createdAt: result.createdAt,
      updatedAt: result.updatedAt,
    );
  }

  @override
  Future<CravingModel> insert(String cravingName, Iterable<CategoryModel> categories) async {
    _logger.log(
      LogLevel.debug,
      'inserting craving $cravingName with categories ${categories.map((category) => category.name)}',
    );
    final addedCravingData = await into(table).insertReturning(
      CravingTableCompanion(
        name: Value(cravingName),
      ),
    );

    _logger.log(LogLevel.debug, 'successful inserted craving $addedCravingData');

    final cravingCategoryMap = categories.map((category) {
      return (addedCravingData.id, category.id);
    });

    _logger.log(LogLevel.debug, 'inserting categories $cravingCategoryMap for craving $cravingName');

    await _cravingCategoryRepository.insertAll(cravingCategoryMap);

    _logger.log(LogLevel.debug, 'successful inserted categories for craving $cravingName');

    return CravingModel(
      id: addedCravingData.id,
      name: cravingName,
      categories: categories,
      createdAt: addedCravingData.createdAt,
      updatedAt: addedCravingData.updatedAt,
    );
  }

  @override
  Future<void> insertAll(Iterable<CravingResponse> cravings) {
    return transaction(() async {
      await batch((batch) {
        for (final craving in cravings) {
          batch.insert(
            table,
            CravingTableCompanion(
              id: Value(craving.id),
              name: Value(craving.name),
            ),
          );
        }
      });

      final cravingCategoryMap = <(int, int)>[];
      for (final craving in cravings) {
        for (final category in craving.categories) {
          cravingCategoryMap.add((craving.id, category));
        }
      }

      await _cravingCategoryRepository.insertAll(cravingCategoryMap);
    });
  }

  @override
  Future<void> replace(CravingModel updatedCravingModel) async {
    // delete all categories for the craving first
    await _cravingCategoryRepository.deleteByCravingId(updatedCravingModel.id);

    // then re-add it again with the new list of categories
    final cravingCategoryMap = updatedCravingModel.categories.map((category) {
      return (updatedCravingModel.id, category.id);
    });

    await _cravingCategoryRepository.insertAll(cravingCategoryMap);

    final isSuccess = await update(table).replace(
      CravingTableData(
        id: updatedCravingModel.id,
        name: updatedCravingModel.name,
        createdAt: updatedCravingModel.createdAt,
        updatedAt: updatedCravingModel.updatedAt,
      ),
    );

    if (!isSuccess) {
      throw InvalidDataException('Failed to update craving $updatedCravingModel');
    }
  }

  @override
  Future<int> remove(int id) async {
    await _cravingCategoryRepository.deleteByCravingId(id);
    await _cravingsHistoryRepository.deleteByCravingId(id);
    await _ignoredCravingsRepository.deleteByCravingId(id);
    return (delete(table)..where((t) => t.id.equals(id))).go();
  }
}
