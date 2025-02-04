import 'dart:async';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/core/repository.dart';
import 'package:kycravings/data/db/cravings_database.dart';
import 'package:kycravings/data/db/repositories/craving_category_repository.dart';
import 'package:kycravings/data/db/tables/craving_history_table.dart';
import 'package:kycravings/domain/models/craving_history_model.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/domain/models/craving_preference_model.dart';

abstract interface class CravingsHistoryRepository implements Repository<CravingHistoryTable, CravingHistoryTableData> {
  Future<Iterable<CravingHistoryModel>> selectAll({required int limit, required int offset});
  Future<Iterable<CravingPreferenceModel>> cravingPreferences();
  Future<CravingHistoryModel> insert(CravingModel craving, {DateTime? createdAt});
  Future<int> deleteByCravingId(int cravingId);
  void remove(int id);
  Future<int> deleteOverflowData();
}

@LazySingleton(as: CravingsHistoryRepository)
class CravingsHistoryRepositoryImpl
    extends BaseRepository<CravingsDatabase, CravingHistoryTable, CravingHistoryTableData>
    implements CravingsHistoryRepository {
  final CravingCategoryRepository _cravingCategoryRepository;

  CravingsHistoryRepositoryImpl(
    this._cravingCategoryRepository,
    super.attachedDatabase,
  );

  @override
  Future<Iterable<CravingHistoryModel>> selectAll({required int limit, required int offset}) async {
    const customQuery = 'SELECT '
        'craving_history_table.id as id, '
        'craving_table.id as craving_id, '
        'craving_table.name as craving_name, '
        'craving_table.created_at as craving_created_at, '
        'craving_table.updated_at as craving_updated_at, '
        'craving_history_table.created_at as created_at '
        'FROM craving_history_table '
        'LEFT JOIN craving_table ON craving_history_table.craving_id=craving_table.id '
        'ORDER BY craving_history_table.created_at DESC '
        'LIMIT ? OFFSET ? ';

    final results = await customSelect(customQuery, variables: [
      Variable.withInt(limit),
      Variable.withInt(offset),
    ]).get();

    final cravingCategoryResults = await _cravingCategoryRepository.selectAll();

    return results.map((result) {
      final cravingHistoryId = result.read<int>('id');
      final cravingId = result.read<int>('craving_id');
      final cravingName = result.read<String>('craving_name');
      final cravingCreatedAt = result.read<DateTime>('craving_created_at');
      final cravingUpdatedAt = result.read<DateTime>('craving_updated_at');
      final createdAt = result.read<DateTime>('created_at');

      // filter by craving ID and get the categories
      final categories = cravingCategoryResults.where((result) => result.$2 == cravingId).map((result) => result.$1);

      return CravingHistoryModel(
        id: cravingHistoryId,
        cravingModel: CravingModel(
          id: cravingId,
          name: cravingName,
          categories: categories,
          createdAt: cravingCreatedAt,
          updatedAt: cravingUpdatedAt,
        ),
        createdAt: createdAt,
      );
    });
  }

  @override
  Future<Iterable<CravingPreferenceModel>> cravingPreferences() async {
    const customQuery = 'SELECT '
        'COUNT(craving_history_table.id) as history_count, '
        'MAX(craving_history_table.created_at) as last_chosen, '
        'craving_table.id as craving_id, '
        'craving_table.name as craving_name, '
        'craving_table.created_at as craving_created_at, '
        'craving_table.updated_at as craving_updated_at '
        'FROM craving_history_table '
        'LEFT JOIN craving_table ON craving_history_table.craving_id=craving_table.id '
        'GROUP BY craving_id';

    final results = await customSelect(customQuery).get();

    final cravingCategoryResults = await _cravingCategoryRepository.selectAll();

    return results.map((result) {
      final cravingId = result.read<int>('craving_id');
      final cravingName = result.read<String>('craving_name');
      final cravingCreatedAt = result.read<DateTime>('craving_created_at');
      final cravingUpdatedAt = result.read<DateTime>('craving_updated_at');
      final historyCount = result.read<int>('history_count');
      final lastChosen = result.read<DateTime>('last_chosen');

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
        preferenceCount: historyCount,
        lastChosen: lastChosen,
      );
    });
  }

  @override
  Future<CravingHistoryModel> insert(CravingModel craving, {DateTime? createdAt}) async {
    final currentDateTime = DateTime.now();
    var dateToInsert = createdAt;

    // if createdAt is the same day
    if (createdAt?.day == currentDateTime.day &&
        createdAt?.month == currentDateTime.month &&
        createdAt?.year == currentDateTime.year) {
      dateToInsert = currentDateTime;
    }

    final addedCravingHistory = await into(table).insertReturning(
      CravingHistoryTableCompanion(
        cravingId: Value(craving.id),
        createdAt: Value(dateToInsert ?? DateTime.now()),
      ),
    );

    // trigger delete overflow data every insert
    unawaited(deleteOverflowData());

    return CravingHistoryModel(
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
  Future<int> remove(int id) async {
    return (delete(table)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<int> deleteOverflowData() async {
    const historyLimit = 1000;
    final latestRecordsQuery = select(table)
      ..orderBy([
        (t) => OrderingTerm.desc(t.createdAt),
      ])
      ..limit(historyLimit);

    final latestRecords = await latestRecordsQuery.get();

    final latestIds = latestRecords.map((r) => r.id).toSet();

    return (delete(table)..where((tbl) => tbl.id.isNotIn(latestIds))).go();
  }
}
