import 'dart:math';

import 'package:flutter/material.dart';
import 'package:genetic_sudoku/main.dart';
import 'package:genetic_sudoku/models/grid.dart';

class GridWidget extends StatelessWidget {
  const GridWidget({
    Key? key,
    required this.grid,
  }) : super(key: key);

  final Grid grid;

  @override
  Widget build(BuildContext context) {
    return Table(
      children: List.generate(
        9,
        (y) => TableRow(
          children: List.generate(
            9,
            (x) => CellWidget(cell: grid.getCell(position: Point(x, y))),
          ),
        ),
      ),
    );
  }
}
