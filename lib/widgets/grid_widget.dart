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
      width: 400,
      child: Table(
        border: TableBorder.symmetric(
          inside: const BorderSide(color: Color(0xFF00003f)),
        ),
        children: List.generate(
          9,
          (y) => TableRow(
            children: List.generate(
              9,
              (x) => CellWidget(
                cell: grid.getCell(position: Point(x, y)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
