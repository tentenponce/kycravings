import 'package:drift/drift.dart';

class CravingHistoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cravingId => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
