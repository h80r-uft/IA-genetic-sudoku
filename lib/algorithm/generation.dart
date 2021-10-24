import 'dart:math';

import 'package:genetic_sudoku/algorithm/chromosome.dart';
import 'package:genetic_sudoku/models/grid.dart';

class Generation {
  Generation({required this.generationNumber, required int size}) {
    population = List.filled(size, Chromosome());
  }

  Generation.reproduce({
    required this.generationNumber,
    required Generation previous,
    required double mutationRate,
  }) {
    final parents = List.generate(
      previous.population.length - 2,
      (index) => previous.getParent(),
    );
    final elitism = previous.fittest;
    final variability = previous.unfittest;

    population = [elitism, variability];

    for (var i = 0; i < parents.length; i += 2) {
      final crossingPoint = Random().nextInt(81);
      population.add(Chromosome.fromParents(
        parents[i],
        parents[i + 1],
        crossingPoint: crossingPoint,
        mutationRate: mutationRate,
      ));
      population.add(Chromosome.fromParents(
        parents[i + 1],
        parents[i],
        crossingPoint: crossingPoint,
        mutationRate: mutationRate,
      ));
    }
  }

  late final List<Chromosome> population;
  final int generationNumber;

  void applyFitness() {
    for (var chromosome in population) {
      chromosome.applyFitness();
    }
  }

  Chromosome getParent({double tournamentSize = 0.1}) {
    final pool = population
      ..shuffle()
      ..take((tournamentSize * population.length).round());
    return pool.reduce((best, e) => e.fitness > best.fitness ? e : best);
  }

  Chromosome get fittest =>
      population.reduce((a, b) => a.fitness > b.fitness ? a : b);

  Chromosome get unfittest =>
      population.reduce((a, b) => a.fitness < b.fitness ? a : b);
}

class GenerationLog {
  GenerationLog({
    required this.fittest,
    required this.unfittest,
    required this.fitness,
    required this.generationNumber,
  });

  GenerationLog.fromGeneration({required Generation generation})
      : fittest = generation.fittest.grid,
        unfittest = generation.unfittest.grid,
        fitness = generation.fittest.fitness,
        generationNumber = generation.generationNumber;

  final Grid fittest;
  final Grid unfittest;
  final int fitness;
  final int generationNumber;
}
