import 'dart:math';

import 'package:genetic_sudoku/models/cell.dart';

/// Representa um gene do cromossomo.
///
/// O gene pode ser observado como cada célula do sudoku.
///
/// * [value] representa o valor do gene.
/// * [_random] é um gerador de aleatoriedade.
class Gene {
  /// Produz um gene aleatório.
  Gene({this.isFixed = false, int? desiredValue}) {
    value = desiredValue ?? _random.nextInt(9) + 1;
  }

  /// Produz um gene a partir de uma célula fixa.
  Gene.fromCell({required Cell cell})
      : value = cell.value,
        isFixed = cell.isFixed;

  /// É o gerador de aleatoriedade utilizado por todos os genes.
  static final _random = Random();

  /// É o valor do gene atualmente observado.
  ///
  /// Pode ser qualquer número no intervalo `[1 ... 9]`.
  late final int value;

  /// Armazena se o gene atual é parte fixa do sudoku.
  final bool isFixed;

  @override
  String toString() {
    return value.toString();
  }
}
