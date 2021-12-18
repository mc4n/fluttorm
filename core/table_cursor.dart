import 'modelbase.dart' show ModelBase;
import 'dart:async';

typedef FnList<T> = Future<List<T>> Function(
    {String orderBy, MapEntry<String, dynamic> filter, int limit, int offset});

typedef FnCount<T> = Future<int> Function({MapEntry<String, dynamic> filter});

class TableCursor<T extends ModelBase<Tkey>, Tkey> {
  final FnList source;
  final int limit;
  final String orderBy;
  final FnCount counter;

  TableCursor(this.source, this.limit,
      {this.orderBy, this.filter, this.counter});

  Future<List<T>> _future(int page) {
    return source(
        filter: filter, limit: limit, offset: page * limit, orderBy: orderBy);
  }

  MapEntry<String, dynamic> filter;

  Future<int> get totalCount async => counter?.call(filter: filter);

  int _pageNum = 0;

  int get pageIndex => _pageNum;

  void reset() => _pageNum = 0;

  Future<List<T>> get current async => getAt(_pageNum);

  Future<List<T>> getAt(int pageNum) async => (await _future(pageNum)) ?? [];

  Future<bool> seek(int pageNum) async {
    final listezittin = await getAt(pageNum);
    return pageNum >= 0 && listezittin != null && listezittin.length != 0;
  }

  Future<bool> moveBack() async {
    if (_pageNum == 0) return false;
    bool res = await seek(_pageNum - 1);
    if (res) _pageNum--;
    return res;
  }

  Future<bool> moveNext() async {
    bool res = await seek(_pageNum + 1);
    if (res) _pageNum++;
    return res;
  }

  int currentPage(int totalLen) => pageIndex + (totalLen == 0 ? 0 : 1);
  int totalPages(int totalLen) => (((totalLen - 1) / limit).floor()) + 1;
}
