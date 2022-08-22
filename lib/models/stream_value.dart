import 'dart:async';

import 'package:casseurs_flutter_kit/models/paginated_list_state.dart';

class StreamValue<T> {
  late T _value;
  T get value => _value;
  final _controller = StreamController<T>.broadcast();

  Stream<T> get stream async* {
    yield* _controller.stream;
  }

  StreamValue(T value) {
    _value = value;
  }

  void set(T value) {
    _value = value;
    _controller.add(_value);
  }
}

class StreamListValue<T> extends StreamValue<List<T>> {  

  StreamListValue(List<T> value) : super(value);  

  void add(T value) {
    _value.add(value);
    _controller.add(_value);
  }

  void removeWhere(bool Function(T element) test) {
    _value.removeWhere(test);
    _controller.add(_value);
  }

  void addOrReplaceIfExistsWhere(bool Function(T element) test, T value) {
    final index = _value.indexWhere(test);
    if (index >= 0) {
      _value[index] = value;
    } else {
      _value.add(value);
    }

    _controller.add(_value);
  }

  void replaceIfExistsWhere(bool Function(T element) test, T value) {
    final index = _value.indexWhere(test);
    if (index >= 0) {
      _value[index] = value;
      _controller.add(_value);
    }
  }
}

class StreamPaginatedListValueState<T> {
  final bool fetching;
  final PaginatedList<T> list;

  const StreamPaginatedListValueState({
    this.fetching = false,
    this.list = const PaginatedList()
  });

  get items => null;

  StreamPaginatedListValueState<T> copyWith({
    bool? fetching,
    PaginatedList<T>? list
  }) {
    return StreamPaginatedListValueState<T>(
      fetching: fetching ?? this.fetching,
      list: list ?? this.list
    );
  }
}

class StreamPaginatedListValue<T> extends StreamValue<StreamPaginatedListValueState<T>> {
  StreamPaginatedListValue({required StreamPaginatedListValueState<T> value}) : super(value);

  factory StreamPaginatedListValue.empty() {
    return StreamPaginatedListValue(value: StreamPaginatedListValueState<T>());
  }

  void setFetching(bool fetching) {
    set(value.copyWith(fetching: fetching));
  }

  void setList(PaginatedList<T> list, { bool fetching = false }) {
    set(
      value.copyWith(
        fetching: fetching,
        list: list
      )
    );
  }

  void addList(PaginatedList<T> list, { bool fetching = false }) {
    set(
      value.copyWith(
        fetching: fetching,
        list: list.copyWith(
          items: [...value.list.items, ...list.items]
        )
      )
    );
  }
}