import 'dart:async';

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