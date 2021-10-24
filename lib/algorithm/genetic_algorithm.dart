import 'package:genetic_sudoku/algorithm/generation.dart';

class GeneticAlgorithm {
  GeneticAlgorithm({
    required this.maxGenerations,
    required this.populationSize,
  });

  final int maxGenerations;
  final int populationSize;
  final generations = <Generation>[];

  void initialize() {
    generations.add(Generation(
      generationNumber: 0,
      size: populationSize,
    )..applyFitness());
  }
}
