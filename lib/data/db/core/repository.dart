import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

abstract interface class Repository<TTable extends Table, TDataObject extends Insertable<TDataObject>> {}

class BaseRepository<TDb extends GeneratedDatabase, TTable extends Table, TDataObject extends Insertable<TDataObject>>
    extends DatabaseAccessor<TDb> implements Repository<TTable, TDataObject> {
  @protected
  TableInfo<TTable, TDataObject> get table =>
      db.allTables.firstWhere((element) => element is TTable) as TableInfo<TTable, TDataObject>;

  BaseRepository(super.attachedDatabase);
}
