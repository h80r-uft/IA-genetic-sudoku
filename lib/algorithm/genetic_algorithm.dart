import 'package:genetic_sudoku/algorithm/generation.dart';

class GeneticAlgorithm {
  GeneticAlgorithm({
    required this.maxGenerations,
    required this.populationSize,
    required this.mutationRate,
  });

  final int maxGenerations;
  final int populationSize;
  final double mutationRate;
  final generations = <Generation>[];
  int _lastGeneration = 0;

  void initialize() {
    generations.add(Generation(
      generationNumber: 0,
      size: populationSize,
    )..applyFitness());
  }

  void evolutionLoop() {
    generations.add(Generation.reproduce(
      generationNumber: generations.length,
      previous: generations.last,
      mutationRate: mutationRate,
    ));
    generations.last.applyFitness();

    _lastGeneration++;

    memoryHandler();
  }

  void memoryHandler() {
    if (generations.length < 3) return;
    if (generations[generations.length - 2].fittest.fitness ==
        generations[generations.length - 3].fittest.fitness) {
      generations.removeAt(generations.length - 2);
    }
  }

  bool isFinished() {
    final reachedMaxGenerations = _lastGeneration >= maxGenerations;
    final reachedRequiredFitness = generations.last.fittest.fitness >= 2025;

    return reachedMaxGenerations || reachedRequiredFitness;
  }
}
