import 'dart:math';

import 'package:genetic_sudoku/algorithm/gene.dart';

class Chromosome {
  Chromosome() {
    genes = List.filled(81, Gene());
  }

  late final List<Gene> genes;
  late int fitness;

  void applyFitness() {
    var mappedGenes = List.generate(
      genes.length,
      (i) => {
        'gene': genes[i],
        'position': Point(i % 9, i ~/ 9),
        'quadrant': [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9]
        ][(i ~/ 9) ~/ 3][(i % 9) ~/ 3],
      },
    );

    fitness = mappedGenes.map((mappedGene) {
      final mappedGeneLine = mappedGenes.where((gene) =>
          (gene['position'] as Point).y == (mappedGene['position'] as Point).y);
      final mappedGeneColumn = mappedGenes.where((gene) =>
          (gene['position'] as Point).x == (mappedGene['position'] as Point).x);
      final mappedGeneQuadrant = mappedGenes.where((gene) =>
          (gene['quadrant'] as int) == (mappedGene['quadrant'] as int));

      final copiesInLine = mappedGeneLine
          .where((e) =>
              (e['gene'] as Gene).value == (mappedGene['gene'] as Gene).value)
          .length;
      final copiesInColumn = mappedGeneColumn
          .where((e) =>
              (e['gene'] as Gene).value == (mappedGene['gene'] as Gene).value)
          .length;
      final copiesInQuadrant = mappedGeneQuadrant
          .where((e) =>
              (e['gene'] as Gene).value == (mappedGene['gene'] as Gene).value)
          .length;

      final copiesInRange =
          copiesInLine + copiesInColumn + copiesInQuadrant - 2;
      final validShapes = [copiesInLine, copiesInColumn, copiesInQuadrant]
          .where((e) => e == 1)
          .length;

      return pow(3, validShapes) - pow(2, copiesInRange) as int;
    }).reduce((total, element) => total + element);
  }

  @override
  String toString() {
    return '<${genes.join('|')}> [$fitness]';
  }
}
