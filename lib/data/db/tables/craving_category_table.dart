import 'package:drift/drift.dart';

class CravingCategoryTable extends Table {
  IntColumn get cravingId => integer()();
  IntColumn get categoryId => integer()();

  @override
  Set<Column> get primaryKey => {cravingId, categoryId};
}
