import 'package:flutter/material.dart';
import 'package:genetic_sudoku/assets/shema_colors.dart';
import 'package:genetic_sudoku/models/cell.dart';

class CellWidget extends StatelessWidget {
  const CellWidget({
    Key? key,
    required this.cell,
  }) : super(key: key);

  final Cell cell;

  @override
  Widget build(BuildContext context) {
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
      height: 400 / 9,
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
          Positioned(
            bottom: 0,
            right: 0,
            child: Icon(
              cell.isFixed ? Icons.lock : Icons.gesture_outlined,
              size: 14,
              color: Colors.grey.withOpacity(0.5),
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
