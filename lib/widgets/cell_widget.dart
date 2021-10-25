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
    final cord = [2, 5];
    final cord2 = [3, 6];

    return Container(
      decoration: BoxDecoration(
        color: cell.square % 2 == 0 ? Colors.black12 : Colors.white,
        border: Border(
          right: cord.contains(cell.position.x)
              ? const BorderSide(width: 2, color: Colors.pink)
              : const BorderSide(color: Colors.transparent),
          bottom: cord.contains(cell.position.y)
              ? const BorderSide(width: 2, color: Colors.pink)
              : const BorderSide(color: Colors.transparent),
          left: cord2.contains(cell.position.x)
              ? const BorderSide(width: 2, color: Colors.pink)
              : const BorderSide(color: Colors.transparent),
          top: cord2.contains(cell.position.y)
              ? const BorderSide(width: 2, color: Colors.pink)
              : const BorderSide(color: Colors.transparent),
        ),
      ),
      height: 500 / 9,
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
}
