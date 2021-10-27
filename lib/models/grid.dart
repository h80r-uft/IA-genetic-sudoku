import 'dart:math';

import 'package:genetic_sudoku/algorithm/chromosome.dart';
import 'package:genetic_sudoku/models/cell.dart';

/// É a representação visual do cromossomo no aplicativo.
///
/// * [cells] é a lista de células que compõem o sudoku.
class Grid {
  /// Gera uma [Grid] em que cada célula possui valor de 0 à 80.
  ///
  /// Função utilizada apenas para testes do aplicativo.
  Grid() {
    cells = List<Cell>.generate(
      81,
      (i) => Cell(
        value: i,
        cellNumber: i,
      ),
    );
  }

  /// Gera uma [Grid] a partir de um [chromosome] válido.
  Grid.fromChromosome(Chromosome chromosome) {
    cells = List<Cell>.generate(
      81,
      (i) => Cell(
        value: chromosome.genes[i].value,
        cellNumber: i,
      ),
    );
  }

  /// Retorna a célula que está na [position] indicada.
  Cell getCell({required Point position}) {
    return cells.firstWhere((cell) => cell.position == position);
  }

  /// Lista de células que compõem o sudoku.
  late final List<Cell> cells;
}
