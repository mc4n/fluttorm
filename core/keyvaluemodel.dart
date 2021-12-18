import 'dbase_manager.dart';
import 'table_base.dart';
import 'modelbase.dart';

class KeyValueModel extends ModelBase<int>
    implements MapEntry<String, dynamic> {
  final String _key;
  final dynamic _value;

  KeyValueModel(int id, this._key, this._value) : super(id: id);

  @override
  get map => {key: value};

  @override
  get key => _key;

  @override
  get value => _value;
}

class KeyValueModelFrom implements ModelFrom<KeyValueModel, int> {
  @override
  modelFrom(int _key, Map<String, dynamic> _map) =>
      KeyValueModel(_key, _map.keys.single, _map.values.single);
}

abstract class KeyValueTable<Tkey> extends TableEntity<KeyValueModel, int> {
  KeyValueTable(String name, TableStorage manager) : super(name, manager);

  Future<dynamic> getValue(String field) async =>
      (await this.first(filter: MapEntry('!?$field', null))).value;

  Future<bool> setValue(String field, dynamic value) async =>
      await insert(KeyValueModel(null, '$field', value));

  Future<bool> unsetValue(String field) async =>
      await deleteOne(filter: MapEntry('!?$field', null));
}
