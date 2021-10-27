import 'dart:math';

/// É a representação visual de um [Gene].
///
/// Pode ser observada como cada célula do tabuleiro do sudoku.
///
/// * [value] é o valor da célula.
/// * [position] é a posição da célula no tabuleiro.
/// * [copiesInRange] é a quantidade de cópias no alcance da célula atual.
/// * [validShape] é a quantidade de formas válidas das quais a célula
/// participa.
class Cell {
  /// Gera uma nova célula com [value] e [cellNumber] informados.
  Cell({
    required this.value,
    required this.cellNumber,
    this.isFixed = false,
  });

  /// Armazena o valor atual da célula.
  ///
  /// Pode ser qualquer número no intervalo `[1 ... 9]`.
  final int value;

  /// Armazena o número ordinal da célula.
  ///
  /// Pode ser qualquer número no intervalo `[0 ... 80]`.
  final int cellNumber;

  /// Armazena quantas células de valor [value] estão presentes no alcance da
  /// célula.
  ///
  /// Inclui a célula atual.
  ///
  /// O alcance seria a linha, a coluna e o quadrado dos quais a célula
  /// participa.
  var copiesInRange = 1;

  /// Armazena quantas formas concluídas a célula faz parte.
  ///
  /// Formas concluídas seriam linhas, colunas e quadrados em que não há
  /// repetição de valor.
  var validShapes = 0;

  /// Armazena se a célula atual é fixa no sudoku.
  final bool isFixed;

  /// Retorna em qual quadrado a célula se encontra.
  int get square => [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ][position.y ~/ 3][position.x ~/ 3];

  /// Retorna a posição da célula atual.
  ///
  /// Utiliza a classe [Point] que possui as coordenadas `x` e `y`.
  ///
  /// A primeira célula do tabuleiro de sudoku teria [position] = `Point(0, 0)`.
  /// Já a última seria `Point(8, 8)`.
  Point get position => Point(cellNumber % 9, cellNumber ~/ 9);

  @override
  String toString() {
    return 'p: $position | c: $copiesInRange | s: $validShapes | v: $value';
  }
}
