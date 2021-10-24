import 'dart:math';

import 'package:genetic_sudoku/algorithm/gene.dart';
import 'package:genetic_sudoku/models/cell.dart';
import 'package:genetic_sudoku/models/grid.dart';

class Chromosome {
  Chromosome() {
    genes = List.generate(81, (i) => Gene());
    grid = Grid.fromChromosome(this);
  }

  Chromosome.fromParents(
    Chromosome parent1,
    Chromosome parent2, {
    required double mutationRate,
  }) {
    final crossingPoint = Random().nextInt(81);
    final genes1 = parent1.genes.sublist(0, crossingPoint);
    final genes2 = parent2.genes.sublist(crossingPoint);
    genes = List.from(genes1)..addAll(genes2);

    _mutate(mutationRate: mutationRate);

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

  void _mutate({required double mutationRate}) {
    for (var i = 0; i < genes.length; i++) {
      if (Random().nextDouble() < mutationRate) {
        genes[i] = Gene();
      }
    }
  }

  @override
  String toString() {
    return '<${genes.join('|')}> [$fitness]';
  }
}
