import 'dart:math';

/// Representa um gene do cromossomo.
///
/// O gene pode ser observado como cada célula do sudoku.
///
/// * [value] representa o valor do gene.
/// * [_random] é um gerador de aleatoriedade.
class Gene {
  /// Produz um gene aleatório.
  Gene() {
    value = _random.nextInt(9) + 1;
  }

  /// É o gerador de aleatoriedade utilizado por todos os genes.
  static final _random = Random();

  /// É o valor do gene atualmente observado.
  ///
  /// Pode ser qualquer número no intervalo `[1 ... 9]`.
  late final int value;

  @override
  String toString() {
    return value.toString();
  }
}
