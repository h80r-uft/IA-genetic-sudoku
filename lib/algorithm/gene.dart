import 'dart:math';

class Gene {
  Gene() {
    value = random.nextInt(9) + 1;
  }

  static var random = Random();
  late final int value;

  @override
  String toString() {
    return value.toString();
  }
}
