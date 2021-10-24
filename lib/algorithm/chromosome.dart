import 'dart:math';

import 'package:genetic_sudoku/algorithm/gene.dart';
import 'package:genetic_sudoku/models/cell.dart';
import 'package:genetic_sudoku/models/grid.dart';

class Chromosome {
  Chromosome() {
    genes = List.generate(81, (i) => Gene());
    grid = Grid.fromChromosome(this);
  }

  late final List<Gene> genes;
  late final Grid grid;
  late int fitness;

  void applyFitness() {
    void evaluateCell({
      required Cell target,
      required List<Cell> line,
      required List<Cell> column,
      required List<Cell> square,
    }) {
      final lineCopies = line.where((e) => e.value == target.value).length;
      final columnCopies = column.where((e) => e.value == target.value).length;
      final squareCopies = square.where((e) => e.value == target.value).length;

      target.copiesInRange = lineCopies + columnCopies + squareCopies - 2;
      target.validShapes = [
        lineCopies,
        columnCopies,
        squareCopies,
      ].where((e) => e == 1).length;
    }

    final cells = grid.cells;

    for (final cell in cells) {
      evaluateCell(
        target: cell,
        line: cells.where((e) => e.position.y == cell.position.y).toList(),
        column: cells.where((e) => e.position.x == cell.position.x).toList(),
        square: cells.where((e) => e.square == cell.square).toList(),
      );
    }

    final fitnessPerGene = grid.cells
        .map((e) => pow(3, e.validShapes) - pow(2, e.copiesInRange) as int);

    fitness = fitnessPerGene.reduce((a, b) => a + b);
  }

  @override
  String toString() {
    return '<${genes.join('|')}> [$fitness]';
  }
}
