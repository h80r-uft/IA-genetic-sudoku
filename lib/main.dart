import 'package:flutter/material.dart';
import 'package:genetic_sudoku/widgets/grid_widget.dart';
import 'package:genetic_sudoku/algorithm/genetic_algorithm.dart';
import 'package:genetic_sudoku/models/cell.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Genetic Sudoku',
      home: GeneticSudoku(),
    );
  }
}

class GeneticSudoku extends StatefulWidget {
  const GeneticSudoku({Key? key}) : super(key: key);

  @override
  State<GeneticSudoku> createState() => _GeneticSudokuState();
}

class _GeneticSudokuState extends State<GeneticSudoku> {
  /// Instância do algoritmo genético
  ///
  /// Configurada para executar até `100.000` gerações com uma população de
  /// `100` cromossomos (sudokus), e uma taxa de mutação de `0.025`, ou seja,
  /// `2.5%`. Utilizando um sudoku difícil, gerado pelo site
  /// [sudoku.com](https://sudoku.com/pt/dificil/).
  ///
  /// A execução será encerrada antes de 100.000 gerações caso o sudoku seja
  /// resolvido pelo algoritmo.
  final solution = GeneticAlgorithm(
    maxGenerations: 100000,
    populationSize: 100,
    mutationRate: 0.025,
    fixedCells: [
      [7, 2],
      [3, 6],
      [2, 8],
      [2, 9],
      [5, 14],
      [1, 16],
      [8, 21],
      [1, 23],
      [4, 24],
      [1, 28],
      [9, 31],
      [6, 32],
      [8, 35],
      [7, 36],
      [6, 37],
      [4, 43],
      [9, 44],
      [1, 57],
      [3, 59],
      [8, 63],
      [1, 65],
      [6, 67],
      [7, 75],
      [6, 79],
      [3, 80],
    ].map((e) => Cell(value: e[0], cellNumber: e[1], isFixed: true)).toList(),
  );

  /// O número da geração atualmente exibida na tela.
  var selectedGeneration = 0;

  /// Indica se o usuário ativou a evolução do algoritmo.
  var isEvolving = false;

  @override
  void initState() {
    solution.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Genetic Sudoku'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: solution.generationsLog.isEmpty
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder(
                    stream: Stream.periodic(const Duration(milliseconds: 50)),
                    builder: (_, __) {
                      if (solution.isFinished()) {
                        isEvolving = false;
                      } else if (isEvolving) {
                        solution.evolutionLoop();
                        selectedGeneration++;
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GridWidget(
                              grid: solution
                                  .generationsLog[selectedGeneration].fittest),
                          Text('Current generation: '
                              '${solution.generationsLog[selectedGeneration].generationNumber}'),
                          Text('Current fitness: ' +
                              solution
                                  .generationsLog[selectedGeneration].fitness
                                  .toString()),
                          Slider(
                            min: 0,
                            max: solution.generationsLog.length - 1,
                            value: selectedGeneration.toDouble(),
                            label: solution.generationsLog[selectedGeneration]
                                .generationNumber
                                .toString(),
                            onChanged: isEvolving
                                ? null
                                : (selection) {
                                    setState(() {
                                      selectedGeneration = selection.round();
                                    });
                                  },
                          ),
                        ],
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: solution.isFinished()
                        ? null
                        : () => setState(() {
                              isEvolving = !isEvolving;
                              selectedGeneration =
                                  solution.generationsLog.last.generationNumber;
                            }),
                    child: Text(isEvolving ? 'Evolving' : 'Evolve'),
                  )
                ],
              ),
      ),
    );
  }
}
