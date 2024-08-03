import 'package:drift/drift.dart';

class CravingTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
}
