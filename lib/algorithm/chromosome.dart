import 'dart:math';

import 'package:genetic_sudoku/algorithm/gene.dart';
import 'package:genetic_sudoku/models/cell.dart';
import 'package:genetic_sudoku/models/grid.dart';

/// Represenda um cromossomo no algoritmo.
///
/// * [genes] é a lista de genes deste cromossomo.
/// * [grid] é a representação visual do cromossomo no aplicativo.
/// * [fitness] é a pontuação deste cromossomo.
class Chromosome {
  /// Cria um cromossomo aleatório.
  ///
  /// Gera aleatoriamente os genes deste cromossomo e armazena sua representação
  /// visual.
  ///
  /// Caso sejam passadas células fixas, estas serão utilizadas para geração dos
  /// genes.
  Chromosome(List<Cell> fixedCells) {
    final fixedSquares = List.generate(
      9,
      (i) => fixedCells.where((e) => e.square == i + 1).toList(),
    );

    final generatedSquares = List.generate(
      9,
      (i) => List.generate(9, (j) => j + 1)
        ..removeWhere(
          (e) =>
              fixedSquares[i].where((element) => element.value == e).isNotEmpty,
        )
        ..shuffle(),
    );

    var currentIndex = 0;
    genes = <Gene>[];

    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 3; j++) {
        for (var k = 0; k < 3; k++) {
          final fixedIndex = fixedCells.indexWhere(
            (element) => element.cellNumber == currentIndex,
          );

          if (fixedIndex == -1) {
            genes.add(Gene(
              desiredValue: generatedSquares[(i ~/ 3) * 3 + j].removeLast(),
            ));
          } else {
            genes.add(Gene.fromCell(cell: fixedCells[fixedIndex]));
          }

          currentIndex++;
        }
      }
    }
    grid = Grid.fromChromosome(this);
  }

  /// Gera um novo cromossomo por reprodução de dois pais.
  ///
  /// Utiliza reprodução com um único ponto de cruzamento, [crossingPoint],
  /// definido aleatoriamente.
  ///
  /// Utiliza a [mutationRate] para definir a chance de mutação de cada gene no
  /// cromossomo.
  Chromosome.fromParents(
    Chromosome parent1,
    Chromosome parent2, {
    required int crossingPoint,
    required double mutationRate,
  }) {
    final selectedSquares1 = List.generate(
      crossingPoint + 1,
      (i) => parent1.grid.cells
          .where(
            (e) => e.square == i + 1,
          )
          .toList(),
    );

    final selectedSquares2 = List.generate(
      8 - crossingPoint,
      (i) => parent2.grid.cells
          .where(
            (e) => e.square == crossingPoint + 2 + i,
          )
          .toList(),
    );

    final allSquares = List<List<Cell>>.from(selectedSquares1)
      ..addAll(selectedSquares2);

    genes = [];

    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 3; j++) {
        for (var k = 0; k < 3; k++) {
          genes.add(
              Gene.fromCell(cell: allSquares[(i ~/ 3) * 3 + j].removeAt(0)));
        }
      }
    }

    // final genes1 = parent1.genes.sublist(0, crossingPoint);
    // final genes2 = parent2.genes.sublist(crossingPoint);
    // genes = List.from(genes1)..addAll(genes2);
    grid = Grid.fromChromosome(this);

    _mutate(mutationRate: mutationRate);
  }

  /// Armazena a lista de genes deste cromossomo.
  ///
  /// Cada gene pode ser compreendido como uma célula do sudoku.
  late List<Gene> genes;

  /// Armazena a representação visual deste cromossomo no aplicativo.
  late Grid grid;

  /// Armazena a pontuação do cromossomo atual.
  late int fitness;

  /// Calcula a pontuação do cromossomo.
  ///
  /// Realiza o cálculo do [fitness] computando a pontuação de cada gene e
  /// somando suas pontuações para atingir o resultado final.
  ///
  /// A pontuação de cada gene é definida como a subtração do exponencial de
  /// base três do número de formas que determinado gene soluciona (linha,
  /// coluna e quadrado) pelo exponencial de base dois do número de repetições
  /// do valor do gene em cada forma.
  ///
  /// ```dart
  /// pow(3, formasSolucionadas) - pow(2, copiasNoAlcance)
  /// ```
  ///
  /// O pior resultado possível, em que todas as células do sudoku tem o mesmo
  /// valor, é `-33.554.431`.
  ///
  /// O melhor resultado possível, em que o sudoku foi solucionado com sucesso,
  /// é `2025`.
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

    final fitnessPerGene =
        grid.cells.map((e) => pow(2, e.copiesInRange) as int);

    fitness = fitnessPerGene.reduce((a, b) => a + b);
  }

  /// Realiza a mutação de genes do cromossomo.
  ///
  /// Para cada gene no cromossomo, caso não seja um gene fixo, há uma chance
  /// [mutationRate] do gene sofrer mutação. Neste caso, o gene é trocado por
  /// outro gene produzido de forma aleatória.
  void _mutate({required double mutationRate}) {
    final random = Random();
    final squares = List.generate(
      9,
      (i) => grid.cells.where((e) => e.square == i + 1).toList(),
    );

    for (final square in squares) {
      if (random.nextDouble() > mutationRate) continue;
      var cell1 = random.nextInt(9);
      while (square[cell1].isFixed) {
        cell1 = random.nextInt(9);
      }

      var cell2 = random.nextInt(9);
      while (square[cell2].isFixed || cell1 == cell2) {
        cell2 = random.nextInt(9);
      }

      final auxiliarCell = square[cell1];
      square[cell1] = square[cell2];
      square[cell2] = auxiliarCell;
    }

    genes = [];

    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 3; j++) {
        for (var k = 0; k < 3; k++) {
          genes.add(Gene.fromCell(cell: squares[(i ~/ 3) * 3 + j].removeAt(0)));
        }
      }
    }

    grid = Grid.fromChromosome(this);
  }

  @override
  String toString() {
    return '<${genes.join('|')}> [$fitness]';
  }
}
