import 'modelbase.dart';
import 'table_base.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

abstract class TableStorage {
  Map<String, TableBase> _tables = Map();
  T table<Tkey, Tval extends ModelBase<Tkey>, T extends TableBase<Tval, Tkey>>(
          String key,
          {T Function(TableStorage, [String tbname]) tableBuilder}) =>
      tableBuilder == null
          ? _tables[key]
          : _tables.putIfAbsent(key, () => tableBuilder(this, key));
}

enum SembastDbTypes {
  MEMORY,
  IO,
  WEB,
}

class SembastDbManager extends TableStorage {
  static StoreRef<int, Map<String, Object>> getIntMapStore(String nm) =>
      intMapStoreFactory.store(nm);

  static StoreRef<String, Map<String, Object>> getStrMapStore(String nm) =>
      stringMapStoreFactory.store(nm);

  final String _dbPath;
  final DatabaseFactory _dbFactory;

  SembastDbManager(
      {String dbName = 'demo', SembastDbTypes dbType = SembastDbTypes.IO})
      : _dbPath = '$dbName.db',
        _dbFactory = dbType == SembastDbTypes.WEB
            ? databaseFactoryWeb
            : (dbType == SembastDbTypes.IO
                ? databaseFactoryIo
                : databaseFactoryMemory);

  Database _db;
  Future<Database> get dbase async =>
      _db ?? (_db = await _dbFactory.openDatabase(_dbPath));
}
