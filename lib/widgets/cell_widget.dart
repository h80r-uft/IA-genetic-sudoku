import 'package:flutter/material.dart';
import 'package:genetic_sudoku/models/cell.dart';

class CellWidget extends StatelessWidget {
  const CellWidget({
    Key? key,
    required this.cell,
  }) : super(key: key);

  final Cell cell;

  @override
  Widget build(BuildContext context) {
    return Text(cell.value.toString());
  }
}
