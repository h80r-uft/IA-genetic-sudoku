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
  final generationsLog = <GenerationLog>[];

  void initialize() {
    generations.add(Generation(
      generationNumber: 0,
      size: populationSize,
    )..applyFitness());

    generationsLog.add(GenerationLog.fromGeneration(
      generation: generations.first,
    ));
  }

  void evolutionLoop() {
    generations.add(Generation.reproduce(
      generationNumber: generations.last.generationNumber + 1,
      previous: generations.last,
      mutationRate: mutationRate,
    ));
    generations.last.applyFitness();

    memoryHandler();
  }

  void memoryHandler() {
    generationsLog.add(GenerationLog.fromGeneration(
      generation: generations.last,
    ));

    generations.removeAt(0);
  }

  bool isFinished() {
    final lastGen = generations.last;
    final reachedMaxGenerations = lastGen.generationNumber >= maxGenerations;
    final reachedRequiredFitness = lastGen.fittest.fitness >= 2025;

    return reachedMaxGenerations || reachedRequiredFitness;
  }
}
