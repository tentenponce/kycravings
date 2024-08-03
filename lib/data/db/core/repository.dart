import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

abstract interface class Repository<TTable extends Table, TDataObject extends Insertable<TDataObject>> {
  Stream<List<TDataObject>> get stream;

  Future<List<TDataObject>> selectAll();

  Future<int> removeAll();

  Future<int> remove(TDataObject dataObject);

  Future<int> add(TDataObject dataObject);

  Future<int> addOrReplace(TDataObject dataObject);

  Future<void> addAll(List<TDataObject> dataObjects);

  Future<bool> replace(TDataObject dataObject);
}

class BaseRepository<TDb extends GeneratedDatabase, TTable extends Table, TDataObject extends Insertable<TDataObject>>
    extends DatabaseAccessor<TDb> implements Repository<TTable, TDataObject> {
  @protected
  TableInfo<TTable, TDataObject> get table =>
      db.allTables.firstWhere((element) => element is TTable) as TableInfo<TTable, TDataObject>;

  @override
  Stream<List<TDataObject>> get stream => select(table).watch();

  BaseRepository(super.attachedDatabase);

  @override
  Future<List<TDataObject>> selectAll() => select(table).get();

  @override
  Future<int> removeAll() => delete(table).go();

  @override
  Future<int> remove(TDataObject dataObject) => delete(table).delete(dataObject);

  @override
  Future<int> add(TDataObject dataObject) => into(table).insert(dataObject);

  @override
  Future<int> addOrReplace(TDataObject dataObject) => into(table).insert(dataObject, mode: InsertMode.insertOrReplace);

  @override
  Future<void> addAll(List<TDataObject> dataObjects) => db.batch((b) => b.insertAll(table, dataObjects));

  @override
  Future<bool> replace(TDataObject dataObject) => update(table).replace(dataObject);
}
