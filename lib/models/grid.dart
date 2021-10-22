import 'dart:math';

import 'package:genetic_sudoku/models/cell.dart';

class Grid {
  Grid() {
    cells = List<Cell>.generate(
        81,
        (i) => Cell(
              value: 0,
              position: Point(i % 9, i ~/ 9),
            ));
  }

  late final List<Cell> cells;
}
