import 'dart:math';

class Gene {
  Gene() {
    value = _random.nextInt(9) + 1;
  }

  static final _random = Random();
  late final int value;

  @override
  String toString() {
    return value.toString();
  }
}
