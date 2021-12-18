abstract class ModelBase<Tkey> {
  final Tkey id;
  ModelBase({this.id});

  List<String> get fields => map.keys.toList();
  List<dynamic> get values => map.values.toList();

  Map<String, dynamic> updateMap<T extends ModelBase<Tkey>>(T newVersion) {
    if (this is! T || this.id != newVersion.id)
      return throw Exception('ERROR: model objects are not the same!');

    return Map.fromEntries(() sync* {
      for (var i = 0; i < values.length; i++) {
        if (fields[i] == newVersion.fields[i] &&
            values[i] != newVersion.values[i]) yield i;
      }
    }()
        .map((i) => MapEntry(newVersion.fields[i], newVersion.values[i])));
  }

  Map<String, dynamic> get map;

  @override
  String toString() => map.toString();
}

abstract class ModelFrom<T extends ModelBase<Tkey>, Tkey> {
  T modelFrom(Tkey _key, Map<String, dynamic> _map);
}
