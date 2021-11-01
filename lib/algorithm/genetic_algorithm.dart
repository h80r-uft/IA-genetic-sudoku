import 'package:genetic_sudoku/algorithm/generation.dart';
import 'package:genetic_sudoku/models/cell.dart';

/// Algoritmo para solução do sudoku simulando evolução.
///
/// ```dart
/// final solution = GeneticAlgorithm(
///   maxGenerations: 1000,
///   populationSize: 100,
///   mutationRate: 0.001,
/// );
/// ```
class GeneticAlgorithm {
  /// Configura o algoritmo genético.
  ///
  /// * [maxGenerations] determina a quantidade de gerações máxima.
  /// * [populationSize] define a quantidade de cromossomos por geração.
  /// * [mutationRate] seleciona a taxa de mutação do processo reprodutivo.
  GeneticAlgorithm({
    required this.maxGenerations,
    required this.populationSize,
    required this.mutationRate,
    required this.reproductionRate,
    required this.fixedCells,
  });

  /// A quantidade máxima de gerações que o algoritmo pode gerar.
  ///
  /// Este valor não será alcançado caso o algoritmo resolva o problema
  /// primeiro.
  final int maxGenerations;

  /// O número de cromossomos por geração.
  final int populationSize;

  /// A chance de mutação do algoritmo.
  final double mutationRate;

  final double reproductionRate;

  /// Uma lista que armazena as células fixas de um sudoku difícil.
  final List<Cell> fixedCells;

  /// Uma lista que armazena as gerações produzidas.
  ///
  /// Para manutenção da memória, essa lista irá possuir no máximo duas gerações
  /// durante a execução do algoritmo, a geração pai e a geração filho.
  /// Neste caso, a geração pai será excluída logo após a conclusão da produção
  /// da nova geração.
  final generations = <Generation>[];

  /// Registro de todas as gerações produzidas.
  ///
  /// Utiliza a classe [GenerationLog], uma versão mais econômica na memória
  /// da classe [Generation] para armazenar os dados relevantes sobre cada
  /// geração, para exibição no aplicativo.
  final generationsLog = <GenerationLog>[];

  /// Inicia o processo evolutivo do algoritmo.
  ///
  /// Produz a primeira geração com cromossomos completamente aleatórios e
  /// já faz a avaliação desta geração aplicando o calculo de pontuação.
  ///
  /// Adiciona esta primeira geração em [generations] e adiciona um registro
  /// desta em [generationsLog].
  void initialize() {
    generations.add(Generation(
      generationNumber: 0,
      populationSize: populationSize,
      fixedCells: fixedCells,
    )..applyFitness());

    generationsLog.add(GenerationLog.fromGeneration(
      generation: generations.first,
    ));
  }

  /// Ciclo de evolução do algoritmo.
  ///
  /// [Ciclo Evolutivo](https://media.springernature.com/m685/springer-static/image/art%3A10.1038%2Fnature14544/MediaObjects/41586_2015_BFnature14544_Fig1_HTML.jpg)
  ///
  /// Produz uma nova geração à partir da geração prévia.
  /// Aplica o cálculo de pontuação para a geração criada.
  ///
  /// Chama o método [memoryHandler] para garantir o estado saudável da memória.
  void evolutionLoop() {
    generations.add(Generation.reproduce(
      generationNumber: generations.last.generationNumber + 1,
      previous: generations.last,
      mutationRate: mutationRate,
      reproductionRate: reproductionRate,
    ));

    memoryHandler();
  }

  /// Método para manutenção da memória utilizada.
  ///
  /// Adiciona um [GenerationLog] à lista de registros de geração e exclui a
  /// geração pai em [generations], reduzindo o gasto de memória do aplicativo.
  void memoryHandler() {
    generationsLog.add(GenerationLog.fromGeneration(
      generation: generations.last,
    ));

    generations.removeAt(0);
  }

  /// Verifica se o processo evolutivo está encerrado.
  ///
  /// Retorna `true` se já tiver alcançado o limite de gerações, ou se o sudoku
  /// tiver sido resolvido.
  bool isFinished() {
    final lastGen = generations.last;
    final reachedMaxGenerations = lastGen.generationNumber >= maxGenerations;
    final reachedRequiredFitness = lastGen.fittest.fitness == 0;

    return reachedMaxGenerations || reachedRequiredFitness;
  }
}
