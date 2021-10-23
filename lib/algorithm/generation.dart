import 'package:genetic_sudoku/algorithm/chromosome.dart';

class Generation {
  Generation({required this.generationNumber}) {
    population = List.filled(100, Chromosome());
  }

  late final List<Chromosome> population;
  final int generationNumber;

  Chromosome get fittest =>
      population.reduce((a, b) => a.fitness > b.fitness ? a : b);
}
