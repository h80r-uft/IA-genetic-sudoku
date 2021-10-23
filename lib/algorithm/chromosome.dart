import 'package:genetic_sudoku/algorithm/gene.dart';

class Chromosome {
  Chromosome() {
    genes = List.filled(81, Gene());
    fitness = -8; // TODO: implement fitness
  }

  late final List<Gene> genes;
  late final int fitness;

  @override
  String toString() {
    return '<${genes.join('|')}>';
  }
}
