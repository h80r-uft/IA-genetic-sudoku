import 'dart:math';

class Cell {
  Cell({required this.value, required this.position});

  final int value;
  final Point position;
  var copiesInRange = 1;
  var validShapes = 0;

  int get square => [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ][position.y ~/ 3][position.x ~/ 3];

  @override
  String toString() {
    return 'p: $position | c: $copiesInRange | s: $validShapes | v: $value';
  }
}
