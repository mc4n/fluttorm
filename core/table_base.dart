import 'modelbase.dart' show ModelBase;
import 'dbase_manager.dart';
import 'table_cursor.dart';

abstract class TableBase<T extends ModelBase<Tkey>, Tkey> {
  String get name;

  TableStorage get manager;

  Future<bool> insert(T item);

  TableCursor<T, Tkey> createCursor(int limit,
      {String orderBy, MapEntry<String, dynamic> filter});

  Future<int> count({MapEntry<String, dynamic> filter});

  Future<List<T>> list(
      {String orderBy,
      MapEntry<String, dynamic> filter,
      int limit,
      int offset});

  Future<T> first(
      {String orderBy,
      MapEntry<String, dynamic> filter,
      Tkey key,
      int limit,
      int offset});

  Future<bool> deleteAll(
      {String orderBy,
      MapEntry<String, dynamic> filter,
      int limit,
      int offset});

  Future<bool> deleteOne(
      {String orderBy, MapEntry<String, dynamic> filter, Tkey key});

  Future<bool> updateOne(T oldVersion, T newVersion);
}

abstract class TableEntity<T extends ModelBase<Tkey>, Tkey>
    implements TableBase<T, Tkey> {
  final String _name;
  final TableStorage _manager;

  TableEntity(this._name, this._manager);

  @override
  get name => _name;

  @override
  get manager => _manager;
}
