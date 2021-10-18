class Nullable<T> {
  final T? _value;

  const Nullable(this._value);

  T? get value {
    return _value;
  }

  static T? copy<T>(Nullable<T>? nullable, T? old) => nullable == null ? old : nullable.value;
}