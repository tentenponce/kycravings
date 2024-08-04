import 'package:drift/drift.dart';

class CravingCategoryTable extends Table {
  IntColumn get cravingId => integer()();
  IntColumn get categoryId => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {cravingId, categoryId};
}
