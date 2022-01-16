class IterableUtils {
  static Iterable<T> addBetweenEach<T>(Iterable<T> items, { T? element }) {
    List<T> list = [];

    for (var i = 0; i < items.length; i++) {
      list.add(items.elementAt(i));

      if (element != null && i < items.length-1) {
        list.add(element);
      }
    }

    return list;
  }
}