import 'package:drift/drift.dart';

class CategoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
}
