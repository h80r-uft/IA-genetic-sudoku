import 'dart:math';

import 'package:flutter/material.dart';
import 'package:genetic_sudoku/models/grid.dart';
import 'package:genetic_sudoku/widgets/cell_widget.dart';

class GridWidget extends StatelessWidget {
  const GridWidget({
    Key? key,
    required this.grid,
  }) : super(key: key);

  final Grid grid;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Table(
        border: TableBorder.all(
          color: Colors.pink,
          width: 2,
        ),
        children: List.generate(
          9,
          (y) => TableRow(
            children: List.generate(
              9,
              (x) => SizedBox(
                height: 500 / 9,
                child: Center(
                  child: CellWidget(
                    cell: grid.getCell(position: Point(x, y)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
