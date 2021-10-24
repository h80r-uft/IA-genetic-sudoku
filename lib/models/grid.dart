import 'dart:math';

import 'package:genetic_sudoku/models/cell.dart';

class Grid {
  Grid() {
    cells = List<Cell>.generate(
        81,
        (i) => Cell(
              value: i,
              position: Point(i % 9, i ~/ 9),
            ));
  }

  Cell getCell({required Point position}) {
    return cells.firstWhere((cell) => cell.position == position);
  }

  late final List<Cell> cells;
}
