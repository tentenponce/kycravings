import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/core/repository.dart';
import 'package:kycravings/data/db/cravings_database.dart';
import 'package:kycravings/data/db/repositories/craving_category_repository.dart';
import 'package:kycravings/data/db/tables/ignored_craving_table.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/domain/models/craving_preference_model.dart';
import 'package:kycravings/domain/models/ignored_craving_model.dart';

abstract interface class IgnoredCravingsRepository implements Repository<IgnoredCravingTable, IgnoredCravingTableData> {
  Future<Iterable<CravingPreferenceModel>> ignoredCravings();
  Future<IgnoredCravingModel> insert(CravingModel craving);
  Future<int> deleteByCravingId(int cravingId);
  Future<int> deletePreviousDays();
}

@LazySingleton(as: IgnoredCravingsRepository)
class IgnoredCravingsRepositoryImpl
    extends BaseRepository<CravingsDatabase, IgnoredCravingTable, IgnoredCravingTableData>
    implements IgnoredCravingsRepository {
  final CravingCategoryRepository _cravingCategoryRepository;

  IgnoredCravingsRepositoryImpl(
    this._cravingCategoryRepository,
    super.attachedDatabase,
  );

  @override
  Future<Iterable<CravingPreferenceModel>> ignoredCravings() async {
    const customQuery = 'SELECT '
        'COUNT(ignored_craving_table.id) as ignored_count, '
        'craving_table.id as craving_id, '
        'craving_table.name as craving_name, '
        'craving_table.created_at as craving_created_at, '
        'craving_table.updated_at as craving_updated_at '
        'FROM ignored_craving_table '
        'LEFT JOIN craving_table ON ignored_craving_table.craving_id=craving_table.id '
        'GROUP BY craving_id';

    final results = await customSelect(customQuery).get();

    final cravingCategoryResults = await _cravingCategoryRepository.selectAll();

    return results.map((result) {
      final cravingId = result.read<int>('craving_id');
      final cravingName = result.read<String>('craving_name');
      final cravingCreatedAt = result.read<DateTime>('craving_created_at');
      final cravingUpdatedAt = result.read<DateTime>('craving_updated_at');
      final ignoredCount = result.read<int>('ignored_count');

      // filter by craving ID and get the categories
      final categories = cravingCategoryResults.where((result) => result.$2 == cravingId).map((result) => result.$1);

      return CravingPreferenceModel(
        cravingModel: CravingModel(
          id: cravingId,
          name: cravingName,
          categories: categories,
          createdAt: cravingCreatedAt,
          updatedAt: cravingUpdatedAt,
        ),
        preferenceCount: ignoredCount,
      );
    });
  }

  @override
  Future<IgnoredCravingModel> insert(CravingModel craving) async {
    final addedCravingHistory = await into(table).insertReturning(
      IgnoredCravingTableCompanion(
        cravingId: Value(craving.id),
      ),
    );

    return IgnoredCravingModel(
      id: addedCravingHistory.id,
      cravingModel: craving,
      createdAt: addedCravingHistory.createdAt,
    );
  }

  @override
  Future<int> deleteByCravingId(int cravingId) {
    return (delete(table)..where((t) => t.cravingId.equals(cravingId))).go();
  }

  @override
  Future<int> deletePreviousDays() {
    return (delete(table)
          ..where((t) => t.createdAt.isSmallerThanValue(DateTime.now().subtract(const Duration(days: 1)))))
        .go();
  }
}
