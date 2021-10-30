import 'dart:math';

import 'package:flutter/material.dart';
import 'package:genetic_sudoku/models/grid.dart';
import 'package:genetic_sudoku/theme/schema_colors.dart';
import 'package:genetic_sudoku/widgets/cell_widget.dart';

class GridWidget extends StatelessWidget {
  const GridWidget({
    Key? key,
    required this.grid,
  }) : super(key: key);

  final Grid grid;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final smallestSize = width < height ? width : height;

    return SizedBox(
      width: smallestSize * 0.60,
      child: Table(
        border: TableBorder.symmetric(
          inside: BorderSide(color: primaryColor),
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
