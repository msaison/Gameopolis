extension CollectionsExtensions<T> on Iterable<T> {
  void forEachIndexed(void Function(T element, int index) action) {
    var index = 0;
    for (var element in this) {
      action(element, index++);
    }
  }
}
