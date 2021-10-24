import 'package:genetic_sudoku/algorithm/chromosome.dart';

class Generation {
  Generation({required this.generationNumber, required int size}) {
    population = List.filled(size, Chromosome());
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
}
