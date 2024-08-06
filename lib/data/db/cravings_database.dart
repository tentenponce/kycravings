import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:kycravings/data/db/tables/category_table.dart';
import 'package:kycravings/data/db/tables/craving_category_table.dart';
import 'package:kycravings/data/db/tables/craving_history_table.dart';
import 'package:kycravings/data/db/tables/craving_table.dart';

part 'cravings_database.g.dart';

@lazySingleton
@DriftDatabase(tables: [
  CravingTable,
  CategoryTable,
  CravingCategoryTable,
  CravingHistoryTable,
])
class CravingsDatabase extends _$CravingsDatabase {
  CravingsDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'cravings_database');
  }
}
