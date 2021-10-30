import 'package:flutter/material.dart';
import 'package:genetic_sudoku/models/cell.dart';
import 'package:genetic_sudoku/theme/schema_colors.dart';

class CellWidget extends StatelessWidget {
  const CellWidget({
    Key? key,
    required this.cell,
  }) : super(key: key);

  final Cell cell;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final smallestSize = width < height ? width : height;

    return Container(
      decoration: BoxDecoration(
        color: cell.isFixed ? secondaryColor : Colors.white,
        border: Border(
          left: customSide(targetPos: cell.position.x, isAfter: true),
          top: customSide(targetPos: cell.position.y, isAfter: true),
          right: customSide(targetPos: cell.position.x),
          bottom: customSide(targetPos: cell.position.y),
        ),
      ),
      height: (smallestSize * 0.60) / 9,
      child: Stack(
        children: [
          Text(
            cell.copiesInRange.toString(),
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
          Center(child: Text(cell.value.toString())),
          Positioned(
            right: 0,
            child: Text(
              cell.validShapes.toString(),
              style: const TextStyle(
                color: Colors.green,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BorderSide customSide({required num targetPos, bool isAfter = false}) {
    if (isAfter) targetPos--;
    final isBold = targetPos == 2 || targetPos == 5;

    return BorderSide(
      width: 2,
      color: isBold ? primaryColor : Colors.transparent,
    );
  }
}
